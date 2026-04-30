import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/barber_model.dart';
import '../cubit/app_cubit.dart';

class AddBarberDialog extends StatefulWidget {
  final String locale;

  const AddBarberDialog({super.key, required this.locale});

  @override
  State<AddBarberDialog> createState() => _AddBarberDialogState();
}

class _AddBarberDialogState extends State<AddBarberDialog> {
  final _nameController = TextEditingController();
  final _specializationsController = TextEditingController();
  final _phoneController = TextEditingController();
  int? _selectedBranchId;

  @override
  void dispose() {
    _nameController.dispose();
    _specializationsController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.bg,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final branches = state is AppLoaded ? state.branches : <Branch>[];
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            AppStrings.get('addNewBarber', widget.locale),
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: _inputDecoration(
                    label: AppStrings.get('barberName', widget.locale),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: _inputDecoration(
                    label: AppStrings.get('phoneNumber', widget.locale),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _specializationsController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: _inputDecoration(
                    label: AppStrings.get('specializations', widget.locale),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: _selectedBranchId,
                  hint: Text(
                    AppStrings.get('selectBranch', widget.locale),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColors.bg,
                  ),
                  dropdownColor: AppColors.surface,
                  style: const TextStyle(color: AppColors.textPrimary),
                  items: branches
                      .map((b) => DropdownMenuItem(
                            value: b.id,
                            child: Text(b.name),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedBranchId = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppStrings.get('cancel', widget.locale),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: _submit,
              child: Text(AppStrings.get('add', widget.locale)),
            ),
          ],
        );
      },
    );
  }

  void _submit() {
    if (_nameController.text.isNotEmpty && _selectedBranchId != null) {
      List<String>? specializations;
      if (_specializationsController.text.isNotEmpty) {
        specializations = _specializationsController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      }
      final barber = Barber(
        id: 0,
        name: _nameController.text,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        email: null,
        specializations: specializations,
        branchId: _selectedBranchId!,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      context.read<AppCubit>().addBarber(barber);
      Navigator.pop(context);
    }
  }
}

void showAddBarberDialog(BuildContext context, String locale) {
  showDialog(context: context, builder: (_) => AddBarberDialog(locale: locale));
}

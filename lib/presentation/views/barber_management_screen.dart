import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/barber_model.dart';
import '../cubit/app_cubit.dart';
import '../widgets/barber_stats_card.dart';

class BarberManagementScreen extends StatelessWidget {
  final String locale;

  const BarberManagementScreen({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 40),
          _buildSectionTitle(context),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                if (state is AppLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AppError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is AppLoaded) {
                  return _buildBarbersGrid(context, state.barbers);
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.get('barberManagement', locale),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.get('staffDirectory', locale),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.get('ourBarbers', locale),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddBarberDialog(context),
          icon: const Icon(Icons.person_add_alt_1, size: 16),
          label: Text(AppStrings.get('addNewBarber', locale)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.border,
            foregroundColor: AppColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarbersGrid(BuildContext context, List<Barber> barbers) {
    if (barbers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.content_cut,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.get('noBarbers', locale),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddBarberDialog(context),
              icon: const Icon(Icons.add),
              label: Text(AppStrings.get('addNewBarber', locale)),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisExtent: 380,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: barbers.length,
      itemBuilder: (context, index) {
        return _BarberCard(barber: barbers[index], locale: locale);
      },
    );
  }

  void _showAddBarberDialog(BuildContext context) {
    final nameController = TextEditingController();
    final specializationsController = TextEditingController();
    final phoneController = TextEditingController();
    int? selectedBranchId;

    showDialog(
      context: context,
      builder: (ctx) => BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final branches = state is AppLoaded ? state.branches : <Branch>[];

          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text(
                AppStrings.get('addNewBarber', locale),
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: AppStrings.get('barberName', locale),
                        labelStyle: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: AppColors.bg,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'رقم الجوال',
                        labelStyle: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: AppColors.bg,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: specializationsController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'التخصصات (مفصولة بفواصل)',
                        labelStyle: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: AppColors.bg,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: selectedBranchId,
                      hint: Text(
                        AppStrings.get('selectBranch', locale),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColors.bg,
                      ),
                      dropdownColor: AppColors.surface,
                      style: const TextStyle(color: AppColors.textPrimary),
                      items: branches
                          .map(
                            (b) => DropdownMenuItem(
                              value: b.id,
                              child: Text(b.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => selectedBranchId = v),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    AppStrings.get('cancel', locale),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        selectedBranchId != null) {
                      List<String>? specializations;
                      if (specializationsController.text.isNotEmpty) {
                        specializations = specializationsController.text
                            .split(',')
                            .map((s) => s.trim())
                            .where((s) => s.isNotEmpty)
                            .toList();
                      }
                      final barber = Barber(
                        id: 0,
                        name: nameController.text,
                        phone: phoneController.text.isNotEmpty ? phoneController.text : null,
                        email: null,
                        specializations: specializations,
                        branchId: selectedBranchId!,
                        isActive: true, // Will create an active barber by default
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );
                      context.read<AppCubit>().addBarber(barber);
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(AppStrings.get('add', locale)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BarberCard extends StatelessWidget {
  final Barber barber;
  final String locale;

  const _BarberCard({required this.barber, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: AppColors.border,
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: barber.statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    barber.getStatus(locale),
                    style: TextStyle(
                      color: barber.statusColor,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            barber.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            barber.specializations?.join(', ') ?? '',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today, size: 14),
                  label: Text(
                    AppStrings.get('schedule', locale),
                    style: const TextStyle(fontSize: 10),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showEditDialog(context),
                  icon: const Icon(Icons.edit_note, size: 14),
                  label: Text(
                    AppStrings.get('edit', locale),
                    style: const TextStyle(fontSize: 10),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Switch(
                value: barber.isActive,
                onChanged: (v) => context
                    .read<AppCubit>()
                    .toggleBarberAvailability(barber.id, v),
                activeColor: AppColors.accentGreen,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _showDeleteDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final nameController = TextEditingController(text: barber.name);
    final specializationsController = TextEditingController(
      text: barber.specializations?.join(', ') ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          AppStrings.get('editBarber', locale),
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: AppStrings.get('barberName', locale),
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.bg,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: specializationsController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'التخصصات (مفصولة بفواصل)',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.bg,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppStrings.get('cancel', locale),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              List<String>? specializations;
              if (specializationsController.text.isNotEmpty) {
                specializations = specializationsController.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();
              }
              context.read<AppCubit>().updateBarber(barber.id, {
                'name': nameController.text,
                'specializations': specializations,
              });
              Navigator.pop(ctx);
            },
            child: Text(AppStrings.get('save', locale)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          '${AppStrings.get('delete', locale)} ${barber.name}?',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          AppStrings.get('confirmDelete', locale),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppStrings.get('cancel', locale),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<AppCubit>().deleteBarber(barber.id);
              Navigator.pop(ctx);
            },
            child: Text(
              AppStrings.get('delete', locale),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

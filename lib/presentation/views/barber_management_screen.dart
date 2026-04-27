import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/barber_model.dart';
import '../cubit/app_cubit.dart';

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
                  return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
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
    return Row(children: [
      Text(AppStrings.get('barberManagement', locale), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
    ]);
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(AppStrings.get('staffDirectory', locale), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(AppStrings.get('ourBarbers', locale), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ]),
      ElevatedButton.icon(
        onPressed: () => _showAddBarberDialog(context),
        icon: const Icon(Icons.person_add_alt_1, size: 16),
        label: Text(AppStrings.get('addNewBarber', locale)),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.border, foregroundColor: AppColors.textPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
    ]);
  }

  Widget _buildBarbersGrid(BuildContext context, List<Barber> barbers) {
    if (barbers.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.content_cut, size: 64, color: AppColors.textSecondary),
        const SizedBox(height: 16),
        Text(AppStrings.get('noBarbers', locale), style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
        const SizedBox(height: 24),
        ElevatedButton.icon(onPressed: () => _showAddBarberDialog(context), icon: const Icon(Icons.add), label: Text(AppStrings.get('addNewBarber', locale))),
      ]));
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 400, mainAxisExtent: 380, crossAxisSpacing: 16, mainAxisSpacing: 16),
      itemCount: barbers.length,
      itemBuilder: (context, index) => _BarberCard(barber: barbers[index], locale: locale, key: ValueKey(barbers[index].id)),
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
              title: Text(AppStrings.get('addNewBarber', locale), style: const TextStyle(color: AppColors.textPrimary)),
              content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: nameController, style: const TextStyle(color: AppColors.textPrimary), decoration: InputDecoration(labelText: AppStrings.get('barberName', locale), labelStyle: const TextStyle(color: AppColors.textSecondary), filled: true, fillColor: AppColors.bg)),
                const SizedBox(height: 16),
                TextField(controller: phoneController, style: const TextStyle(color: AppColors.textPrimary), decoration: InputDecoration(labelText: AppStrings.get('phoneNumber', locale), labelStyle: const TextStyle(color: AppColors.textSecondary), filled: true, fillColor: AppColors.bg)),
                const SizedBox(height: 16),
                TextField(controller: specializationsController, style: const TextStyle(color: AppColors.textPrimary), decoration: InputDecoration(labelText: AppStrings.get('specializations', locale), labelStyle: const TextStyle(color: AppColors.textSecondary), filled: true, fillColor: AppColors.bg)),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: selectedBranchId,
                  hint: Text(AppStrings.get('selectBranch', locale), style: const TextStyle(color: AppColors.textSecondary)),
                  decoration: const InputDecoration(filled: true, fillColor: AppColors.bg),
                  dropdownColor: AppColors.surface,
                  style: const TextStyle(color: AppColors.textPrimary),
                  items: branches.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))).toList(),
                  onChanged: (v) => setState(() => selectedBranchId = v),
                ),
              ])),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppStrings.get('cancel', locale), style: const TextStyle(color: AppColors.textSecondary))),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && selectedBranchId != null) {
                      List<String>? specializations;
                      if (specializationsController.text.isNotEmpty) {
                        specializations = specializationsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
                      }
                      final barber = Barber(id: 0, name: nameController.text, phone: phoneController.text.isNotEmpty ? phoneController.text : null, email: null, specializations: specializations, branchId: selectedBranchId!, isActive: true, createdAt: DateTime.now(), updatedAt: DateTime.now());
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

  const _BarberCard({required this.barber, required this.locale, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final currentBarber = state is AppLoaded ? state.barbers.firstWhere((b) => b.id == barber.id, orElse: () => barber) : barber;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white24)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              Container(height: 120, width: double.infinity, decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.person, size: 60, color: AppColors.border)),
              Positioned(bottom: 8, right: 8, child: _buildStatusBadge(currentBarber, locale, context)),
            ]),
            const SizedBox(height: 16),
            Text(currentBarber.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(currentBarber.specializations?.join(', ') ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 20),
            Row(children: [
              _BarberToggleSwitch(barberId: currentBarber.id, currentValue: currentBarber.isActive),
              const Spacer(),
              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => _showDeleteDialog(context, currentBarber)),
            ]),
          ]),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Barber barber) {
    final nameController = TextEditingController(text: barber.name);
    final specializationsController = TextEditingController(text: barber.specializations?.join(', ') ?? '');
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(AppStrings.get('editBarber', locale), style: const TextStyle(color: AppColors.textPrimary)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameController, style: const TextStyle(color: AppColors.textPrimary), decoration: InputDecoration(labelText: AppStrings.get('barberName', locale), labelStyle: const TextStyle(color: AppColors.textSecondary), filled: true, fillColor: AppColors.bg)),
        const SizedBox(height: 16),
        TextField(controller: specializationsController, style: const TextStyle(color: AppColors.textPrimary), decoration: InputDecoration(labelText: AppStrings.get('specializations', locale), labelStyle: const TextStyle(color: AppColors.textSecondary), filled: true, fillColor: AppColors.bg)),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppStrings.get('cancel', locale), style: const TextStyle(color: AppColors.textSecondary))),
        ElevatedButton(
          onPressed: () {
            List<String>? specializations;
            if (specializationsController.text.isNotEmpty) { specializations = specializationsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(); }
            context.read<AppCubit>().updateBarber(barber.id, {'name': nameController.text, 'specializations': specializations});
            Navigator.pop(ctx);
          },
          child: Text(AppStrings.get('save', locale)),
        ),
      ],
    ));
  }

  void _showDeleteDialog(BuildContext context, Barber barber) {
    debugPrint('>>> [BARBER_DELETE] Delete dialog shown for: ${barber.name} (id: ${barber.id})');
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('${AppStrings.get('delete', locale)} ${barber.name}?', style: const TextStyle(color: AppColors.textPrimary)),
      content: Text(AppStrings.get('confirmDelete', locale), style: const TextStyle(color: AppColors.textSecondary)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppStrings.get('cancel', locale), style: const TextStyle(color: AppColors.textSecondary))),
        TextButton(onPressed: () { 
          debugPrint('>>> [BARBER_DELETE] Confirm delete for: ${barber.id}');
          context.read<AppCubit>().deleteBarber(barber.id); 
          Navigator.pop(ctx); 
        }, child: Text(AppStrings.get('delete', locale), style: const TextStyle(color: Colors.red))),
      ],
    ));
  }

  Widget _buildStatusBadge(Barber barber, String locale, BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: barber.statusColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)), child: Text(barber.getStatus(locale), style: TextStyle(color: barber.statusColor, fontSize: 8, fontWeight: FontWeight.bold))),
      color: AppColors.surface,
      onSelected: (String value) {
        bool newIsActive = value != 'off';
        if (value == 'away') newIsActive = false;
        if (newIsActive != barber.isActive) { context.read<AppCubit>().toggleBarberAvailability(barber.id, newIsActive); }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(value: 'on_duty', child: Row(children: [Icon(Icons.power_settings_new, color: Colors.greenAccent, size: 16), const SizedBox(width: 8), Text(AppStrings.get('onDuty', locale), style: const TextStyle(color: Colors.greenAccent))])),
        PopupMenuItem(value: 'away', child: Row(children: [Icon(Icons.watch_later, color: Colors.amberAccent, size: 16), const SizedBox(width: 8), Text(AppStrings.get('away', locale), style: const TextStyle(color: Colors.amberAccent))])),
        PopupMenuItem(value: 'off', child: Row(children: [Icon(Icons.power_off, color: Colors.grey, size: 16), const SizedBox(width: 8), Text(AppStrings.get('offToday', locale), style: const TextStyle(color: Colors.grey))])),
      ],
    );
  }
}

class _BarberToggleSwitch extends StatefulWidget {
  final int barberId;
  final bool currentValue;
  const _BarberToggleSwitch({required this.barberId, required this.currentValue, super.key});

  @override
  State<_BarberToggleSwitch> createState() => _BarberToggleSwitchState();
}

class _BarberToggleSwitchState extends State<_BarberToggleSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.currentValue;
  }

  @override
  void didUpdateWidget(covariant _BarberToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentValue != widget.currentValue) {
      _value = widget.currentValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listener: (context, state) {
        if (state is AppLoaded) {
          final barber = state.barbers.where((b) => b.id == widget.barberId).firstOrNull;
          if (barber != null && barber.isActive != _value) {
            setState(() => _value = barber.isActive);
          }
        }
      },
      child: Switch(
        value: _value,
        onChanged: (v) {
          setState(() => _value = v);
          context.read<AppCubit>().toggleBarberAvailability(widget.barberId, v);
        },
        activeTrackColor: AppColors.accentGreen,
      ),
    );
  }
}
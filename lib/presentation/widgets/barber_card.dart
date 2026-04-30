import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/barber_model.dart';
import '../cubit/app_cubit.dart';
import 'barber_toggle_switch.dart';

class BarberCard extends StatelessWidget {
  final Barber barber;
  final String locale;

  const BarberCard({super.key, required this.barber, required this.locale});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final currentBarber = state is AppLoaded
            ? state.barbers.firstWhere(
                (b) => b.id == barber.id,
                orElse: () => barber,
              )
            : barber;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
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
                    child: _buildStatusBadge(currentBarber, context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                currentBarber.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentBarber.specializations?.join(', ') ?? '',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  BarberToggleSwitch(
                    barberId: currentBarber.id,
                    currentValue: currentBarber.isActive,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _showDeleteDialog(context, currentBarber),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Barber barber) {
    debugPrint(
      '>>> [BARBER_DELETE] Delete dialog shown for: ${barber.name} (id: ${barber.id})',
    );
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
              debugPrint('>>> [BARBER_DELETE] Confirm delete for: ${barber.id}');
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

  Widget _buildStatusBadge(Barber barber, BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: barber.statusColor.withValues(alpha: 0.2),
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
      color: AppColors.surface,
      onSelected: (String value) {
        bool newIsActive = value != 'off';
        if (value == 'away') newIsActive = false;
        if (newIsActive != barber.isActive) {
          context
              .read<AppCubit>()
              .toggleBarberAvailability(barber.id, newIsActive);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'on_duty',
          child: Row(
            children: [
              Icon(
                Icons.power_settings_new,
                color: Colors.greenAccent,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.get('onDuty', locale),
                style: const TextStyle(color: Colors.greenAccent),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'away',
          child: Row(
            children: [
              Icon(Icons.watch_later, color: Colors.amberAccent, size: 16),
              const SizedBox(width: 8),
              Text(
                AppStrings.get('away', locale),
                style: const TextStyle(color: Colors.amberAccent),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'off',
          child: Row(
            children: [
              Icon(Icons.power_off, color: Colors.grey, size: 16),
              const SizedBox(width: 8),
              Text(
                AppStrings.get('offToday', locale),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

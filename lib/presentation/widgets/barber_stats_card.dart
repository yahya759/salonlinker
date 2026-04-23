import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class BarberStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subValue;
  final String subText;

  const BarberStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.subValue,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  subValue,
                  style: const TextStyle(
                    color: AppColors.accentGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subText,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class BarberStatsSection extends StatelessWidget {
  final String locale;

  const BarberStatsSection({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BarberStatsCard(
            title: AppStrings.get('totalAppointments', locale),
            value: '42',
            subValue: '+12%',
            subText: AppStrings.get('activeBookingsWeek', locale),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: BarberStatsCard(
            title: AppStrings.get('availableSlots', locale),
            value: '08',
            subValue: AppStrings.get('today', locale),
            subText: AppStrings.get('acrossAllStations', locale),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: BarberStatsCard(
            title: AppStrings.get('retentionRate', locale),
            value: '94%',
            subValue: 'Elite',
            subText: AppStrings.get('customerLoyalty', locale),
          ),
        ),
      ],
    );
  }
}

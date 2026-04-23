import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/booking_model.dart';
import '../cubit/locale_cubit.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state is LocaleChanged
        ? (context.watch<LocaleCubit>().state as LocaleChanged).locale
        : 'ar';

    final isConfirmed = booking.status == BookingStatus.confirmed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.sidebarActive,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.textSecondary,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.clientName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.service,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          BookingMeta(
            label: AppStrings.get('stylist', locale),
            value: booking.stylist,
            icon: Icons.person,
          ),
          const SizedBox(width: 24),
          BookingMeta(
            label: AppStrings.get('schedule', locale),
            value: booking.schedule,
            icon: null,
          ),
          const Spacer(),
          StatusBadge(isConfirmed: isConfirmed, locale: locale),
        ],
      ),
    );
  }
}

class BookingMeta extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const BookingMeta({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 9,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.textSecondary, size: 12),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StatusBadge extends StatelessWidget {
  final bool isConfirmed;
  final String locale;

  const StatusBadge({
    super.key,
    required this.isConfirmed,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: isConfirmed ? AppColors.accentGreen : AppColors.pending,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        AppStrings.get(isConfirmed ? 'confirmed' : 'pending', locale),
        style: TextStyle(
          color: isConfirmed
              ? AppColors.confirmedText
              : AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

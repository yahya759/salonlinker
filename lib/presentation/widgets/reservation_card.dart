import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/barber_model.dart';
import '../cubit/app_cubit.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final String locale;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final isConfirmed = reservation.status == ReservationStatus.confirmed;

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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                reservation.startTime,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reservation.clientName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${reservation.serviceName} • ${reservation.barberName ?? ""}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isConfirmed
                  ? AppColors.accentGreen.withOpacity(0.1)
                  : Colors.orangeAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isConfirmed
                  ? AppStrings.get('confirmed', locale)
                  : AppStrings.get('pending', locale),
              style: TextStyle(
                color: isConfirmed
                    ? AppColors.accentGreen
                    : Colors.orangeAccent,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (!isConfirmed)
            IconButton(
              icon: const Icon(
                Icons.check_circle_outline,
                color: AppColors.accentGreen,
              ),
              onPressed: () =>
                  context.read<AppCubit>().confirmReservation(reservation.id),
            ),
          IconButton(
            icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
            onPressed: () =>
                context.read<AppCubit>().cancelReservation(reservation.id),
          ),
        ],
      ),
    );
  }
}

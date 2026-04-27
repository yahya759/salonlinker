import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/barber_model.dart';
import '../cubit/app_cubit.dart';

String _formatTime(String timeStr) {
  try {
    final parts = timeStr.split(':');
    if (parts.length < 2) return timeStr;
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  } catch (_) {
    return timeStr;
  }
}

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final String locale;
  final List<Service> services;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.locale,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    final isConfirmed = reservation.status == ReservationStatus.confirmed;
    final serviceName = reservation.serviceName.isNotEmpty 
        ? reservation.serviceName 
        : (services.cast<Service?>().firstWhere(
            (s) => s?.id == reservation.serviceId,
            orElse: () => null,
          )?.name ?? '');
    debugPrint('ReservationCard - serviceName: $serviceName, serviceId: ${reservation.serviceId}');

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
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                _formatTime(reservation.startTime),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
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
                  '$serviceName • ${reservation.barberName ?? ""}',
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
        ],
      ),
    );
  }
}

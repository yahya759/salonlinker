import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/barber_model.dart';
import '../widgets/reservation_card.dart';

class ScheduleScreen extends StatelessWidget {
  final String locale;
  final List<Reservation> reservations;
  final bool showToday;
  final List<Service> services;

  const ScheduleScreen({
    super.key,
    required this.locale,
    required this.reservations,
    required this.showToday,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.get(
                  'schedule',
                  locale,
                ),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      AppStrings.get(
                        'reservationsCount',
                        locale,
                      ).replaceFirst('{count}', reservations.length.toString()),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (reservations.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 80,
                    color: AppColors.border,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.get('noReservations', locale),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 800;

                if (isMobile) {
return Column(
                    children: reservations
                        .map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ReservationCard(
                              reservation: r,
                              locale: locale,
                              services: services,
                            ),
                          ),
                        )
                        .toList(),
                  );
                }

                return Column(
                    children: reservations
                        .map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ReservationCard(
                              reservation: r,
                              locale: locale,
                              services: services,
                            ),
                          ),
                      )
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}

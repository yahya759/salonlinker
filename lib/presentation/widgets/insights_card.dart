import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/barber_model.dart';
import '../cubit/locale_cubit.dart';

class InsightsSummaryCard extends StatelessWidget {
  final List<Reservation> reservations;
  final List<Service> services;

  const InsightsSummaryCard({
    super.key,
    required this.reservations,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state is LocaleChanged
        ? (context.watch<LocaleCubit>().state as LocaleChanged).locale
        : 'ar';

    double totalRevenue = 0.0;
    int validReservations = 0;
    for (var res in reservations) {
      if (res.status != ReservationStatus.cancelled) {
        validReservations++;
        final service = services.cast<Service?>().firstWhere(
          (s) => s?.id == res.serviceId,
          orElse: () => null,
        );
        if (service != null) {
          totalRevenue += double.tryParse(service.price) ?? 0.0;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.get('insightsSummary', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 8,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.get('todaysRevenue', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '\$${totalRevenue.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.trending_up,
                color: AppColors.accentGreen,
                size: 14,
              ),
              const SizedBox(width: 2),
              Flexible(
                child: Text(
                  locale == 'ar' ? '+12% من昨天' : '+12% FROM YESTERDAY',
                  style: const TextStyle(
                    color: AppColors.accentGreen,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.get('reservations', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$validReservations',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: validReservations / 20.0,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.textPrimary,
              ),
              minHeight: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.get('liveActivity', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 8,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          LiveActivityItem(
            richText: TextSpan(
              children: [
                TextSpan(
                  text: 'Elias ',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
                TextSpan(
                  text: locale == 'ar' ? 'finished a ' : 'finished a ',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                TextSpan(
                  text: 'Beard Trim ',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
                TextSpan(
                  text: locale == 'ar'
                      ? 'for client Sarah J.'
                      : 'for client Sarah J.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          LiveActivityItem(
            richText: TextSpan(
              children: [
                TextSpan(
                  text: 'Booking ',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
                TextSpan(
                  text: locale == 'ar'
                      ? 'created for 8:00 PM by New Client.'
                      : 'created for 8:00 PM by New Client.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LiveActivityItem extends StatelessWidget {
  final TextSpan richText;
  const LiveActivityItem({super.key, required this.richText});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.accentGreen,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: RichText(text: richText)),
      ],
    );
  }
}

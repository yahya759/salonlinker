import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../cubit/app_cubit.dart';
import '../cubit/locale_cubit.dart';
import '../widgets/insights_card.dart';
import '../widgets/on_duty_card.dart';
import '../widgets/reservation_card.dart';
import '../widgets/today_tomorrow_toggle.dart';
import 'barber_management_screen.dart';
import 'client_management_screen.dart';
import 'campaign_management_screen.dart';
import 'schedule_screen.dart';
import 'statistics_screen.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (state is AppLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AppError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(state.message, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<AppCubit>().loadAll(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is! AppLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final locale = context.watch<LocaleCubit>().state is LocaleChanged
            ? (context.watch<LocaleCubit>().state as LocaleChanged).locale
            : 'ar';

        // Navigation
        if (state.selectedNavIndex == 3) {
          return BarberManagementScreen(locale: locale);
        } else if (state.selectedNavIndex == 2) {
          return Expanded(child: ClientDirectoryScreen(locale: locale));
        } else if (state.selectedNavIndex == 5) {
          return Expanded(child: CampaignManagementScreen(locale: locale));
        } else if (state.selectedNavIndex == 1) {
          return Expanded(
            child: ScheduleScreen(
              locale: locale,
              reservations: state.allReservations,
              showToday: false,
              services: state.services,
            ),
          );
        } else if (state.selectedNavIndex == 4) {
          return Expanded(child: StatisticsScreen(locale: locale));
        }

        // Dashboard (index 0)
        return _buildDashboard(context, state, locale);
      },
    );
  }

  Widget _buildDashboard(BuildContext context, AppLoaded state, String locale) {
    final reservations = state.showToday
        ? state.todayReservations
        : state.tomorrowReservations;

    return RefreshIndicator(
      onRefresh: () => context.read<AppCubit>().loadAll(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get('barbershopDashboard', locale),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.get('todaysBookings', locale),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                TodayTomorrowToggle(
                  showToday: state.showToday,
                  onToggle: (v) =>
                      context.read<AppCubit>().toggleTodayTomorrow(v),
                ),
              ],
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 800;

                if (isMobile) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...reservations.map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ReservationCard(
                            reservation: r,
                            locale: locale,
                            services: state.services,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InsightsSummaryCard(
                        reservations: reservations,
                        services: state.services,
                      ),
                      const SizedBox(height: 16),
                      OnDutyCard(barbers: state.barbers),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: reservations
                            .map(
                              (r) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ReservationCard(
                                  reservation: r,
                                  locale: locale,
                                  services: state.services,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 230,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InsightsSummaryCard(
                            reservations: reservations,
                            services: state.services,
                          ),
                          const SizedBox(height: 16),
                          OnDutyCard(barbers: state.barbers),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 100), // مساحة إضافية للتم裤
          ],
        ),
      ),
    );
  }
}

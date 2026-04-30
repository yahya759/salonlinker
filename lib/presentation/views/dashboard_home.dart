import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/barber_model.dart';
import '../cubit/app_cubit.dart';
import '../cubit/locale_cubit.dart';
import '../widgets/insights_card.dart';
import '../widgets/on_duty_card.dart';
import '../widgets/reservation_card.dart';
import '../widgets/today_tomorrow_toggle.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (state is! AppLoaded) {
          return const SizedBox();
        }

        final locale = _getLocale(context);
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
                _buildHeader(context, locale, state),
                const SizedBox(height: 24),
                _buildContent(reservations, state, locale),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getLocale(BuildContext context) {
    final state = context.watch<LocaleCubit>().state;
    if (state is LocaleChanged) {
      return state.locale;
    }
    return 'ar';
  }

  Widget _buildHeader(
    BuildContext context,
    String locale,
    AppLoaded state,
  ) {
    return Row(
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
    );
  }

  Widget _buildContent(
    List<Reservation> reservations,
    AppLoaded state,
    String locale,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        if (isMobile) {
          return _buildMobileLayout(reservations, state, locale);
        }

        return _buildDesktopLayout(reservations, state, locale);
      },
    );
  }

  Widget _buildMobileLayout(
    List<Reservation> reservations,
    AppLoaded state,
    String locale,
  ) {
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

  Widget _buildDesktopLayout(
    List<Reservation> reservations,
    AppLoaded state,
    String locale,
  ) {
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
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/app_cubit.dart';
import '../cubit/locale_cubit.dart';
import 'barber_management_screen.dart';
import 'campaign_management_screen.dart';
import 'client_management_screen.dart';
import 'dashboard_home.dart';
import 'schedule_screen.dart';
import 'statistics_screen.dart';

class NavigationRouter extends StatelessWidget {
  const NavigationRouter({super.key});

  String _getLocale(BuildContext context) {
    final state = context.watch<LocaleCubit>().state;
    if (state is LocaleChanged) {
      return state.locale;
    }
    return 'ar';
  }

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
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
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

        final locale = _getLocale(context);

        return _buildScreen(state, locale);
      },
    );
  }

  Widget _buildScreen(AppLoaded state, String locale) {
    switch (state.selectedNavIndex) {
      case 0:
        return const DashboardHome();
      case 1:
        return Expanded(
          child: ScheduleScreen(
            locale: locale,
            reservations: state.allReservations,
            showToday: false,
            services: state.services,
          ),
        );
      case 2:
        return Expanded(child: ClientDirectoryScreen(locale: locale));
      case 3:
        return BarberManagementScreen(locale: locale);
      case 4:
        return Expanded(child: StatisticsScreen(locale: locale));
      case 5:
        return Expanded(child: CampaignManagementScreen(locale: locale));
      default:
        return const DashboardHome();
    }
  }
}

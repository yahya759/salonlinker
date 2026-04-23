import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/barber_model.dart';
import '../cubit/app_cubit.dart';
import '../cubit/locale_cubit.dart';

class StatisticsScreen extends StatelessWidget {
  final String locale;

  const StatisticsScreen({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            if (state is! AppLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 40),
                _buildStatsCards(state),
                const SizedBox(height: 40),
                _buildChartsSection(state),
                const SizedBox(height: 40),
                _buildTopPerformers(state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.get('analytics', locale),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        const Icon(Icons.notifications_none, color: AppColors.textSecondary),
        const SizedBox(width: 20),
        const CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildStatsCards(AppLoaded state) {
    final totalReservations =
        state.todayReservations.length + state.tomorrowReservations.length;
    final confirmedCount = state.todayReservations
        .where((r) => r.status == ReservationStatus.confirmed)
        .length;
    final pendingCount = state.todayReservations
        .where((r) => r.status == ReservationStatus.pending)
        .length;
    final availableBarbers = state.barbers.where((b) => b.isActive).length;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: AppStrings.get('totalReservations', locale),
            value: totalReservations.toString(),
            subValue:
                '+${confirmedCount} ${AppStrings.get('confirmed', locale)}',
            icon: Icons.calendar_today,
            color: AppColors.accentGreen,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: AppStrings.get('pendingReservations', locale),
            value: pendingCount.toString(),
            subValue: AppStrings.get('waiting', locale),
            icon: Icons.pending_actions,
            color: Colors.orangeAccent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: AppStrings.get('availableBarbers', locale),
            value: '$availableBarbers/${state.barbers.length}',
            subValue: AppStrings.get('onDuty', locale),
            icon: Icons.content_cut,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: AppStrings.get('totalBarbers', locale),
            value: state.barbers.length.toString(),
            subValue: AppStrings.get('staff', locale),
            icon: Icons.people,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildChartsSection(AppLoaded state) {
    final confirmedCount = state.todayReservations
        .where((r) => r.status == ReservationStatus.confirmed)
        .length;
    final cancelledCount = state.todayReservations
        .where((r) => r.status == ReservationStatus.cancelled)
        .length;
    final pendingCount = state.todayReservations
        .where((r) => r.status == ReservationStatus.pending)
        .length;
    final total = state.todayReservations.isEmpty
        ? 1
        : state.todayReservations.length;
    final confirmedPercent = (confirmedCount / total * 100).round();
    final pendingPercent = (pendingCount / total * 100).round();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.get('dailyPerformance', locale),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        children: [
                          CircularProgressIndicator(
                            value: confirmedPercent / 100,
                            strokeWidth: 12,
                            backgroundColor: AppColors.border,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.accentGreen,
                            ),
                          ),
                          Center(
                            child: Text(
                              '$confirmedPercent%',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LegendItem(
                          color: AppColors.accentGreen,
                          label: AppStrings.get('confirmed', locale),
                          value: confirmedCount,
                        ),
                        const SizedBox(height: 8),
                        _LegendItem(
                          color: Colors.orangeAccent,
                          label: AppStrings.get('pending', locale),
                          value: pendingCount,
                        ),
                        const SizedBox(height: 8),
                        _LegendItem(
                          color: Colors.redAccent,
                          label: AppStrings.get('cancelled', locale),
                          value: cancelledCount,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.get('occupancyRate', locale),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '${(state.barbers.isEmpty ? 0 : state.barbers.where((b) => b.isActive).length / state.barbers.length * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.get('barbersWorking', locale),
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: state.barbers.isEmpty
                        ? 0
                        : state.barbers.where((b) => b.isActive).length /
                              state.barbers.length,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.accentGreen,
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopPerformers(AppLoaded state) {
    final availableBarbers = state.barbers.where((b) => b.isActive).toList();

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
            AppStrings.get('barbersOnDuty', locale),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          if (availableBarbers.isEmpty)
            Center(
              child: Text(
                AppStrings.get('noBarbersOnDuty', locale),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: availableBarbers.length,
              itemBuilder: (context, index) {
                final barber = availableBarbers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.bg,
                        child: const Icon(
                          Icons.person,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              barber.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              barber.specializations?.join(', ') ?? '',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          AppStrings.get('onDuty', locale),
                          style: const TextStyle(
                            color: AppColors.accentGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subValue;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subValue,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subValue,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int value;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(width: 8),
        Text(
          '$value',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

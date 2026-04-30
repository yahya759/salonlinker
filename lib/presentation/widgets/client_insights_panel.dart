import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../cubit/locale_cubit.dart';

class ClientInsightsPanel extends StatelessWidget {
  final List<dynamic> allUsers;

  const ClientInsightsPanel({super.key, required this.allUsers});

  String _getLocale(BuildContext context) {
    final state = context.watch<LocaleCubit>().state;
    if (state is LocaleChanged) {
      return state.locale;
    }
    return 'ar';
  }

  @override
  Widget build(BuildContext context) {
    final locale = _getLocale(context);

    final totalUsers = allUsers.length;
    final adminCount = allUsers.where((u) => u.role == 'admin').length;
    final barberCount = allUsers.where((u) => u.role == 'barber').length;
    final regularUserCount = allUsers.where((u) => u.role == 'user').length;

    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final recentActiveUsers = allUsers
        .where((u) => u.lastSignedIn.isAfter(sevenDaysAgo))
        .length;

    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final newUsers = allUsers
        .where((u) => u.createdAt.isAfter(thirtyDaysAgo))
        .length;

    final retainedUsers = allUsers
        .where((u) => u.lastSignedIn.isAfter(u.createdAt))
        .length;
    final retentionRate =
        totalUsers > 0 ? (retainedUsers / totalUsers * 100) : 0.0;

    final topUsers = allUsers.toList()
      ..sort((a, b) => b.lastSignedIn.compareTo(a.lastSignedIn));
    final topPerformers = topUsers.take(3).toList();

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  AppStrings.get('totalClientBase', locale),
                  totalUsers.toString(),
                  AppColors.accentGreen,
                  Icons.people_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'الصلاحيات',
                  '$adminCount مدير\n$barberCount حلاق\n$regularUserCount عميل',
                  Colors.blueAccent,
                  Icons.admin_panel_settings_outlined,
                  isSmall: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  AppStrings.get('retentionRate', locale),
                  '${retentionRate.toStringAsFixed(1)}%',
                  Colors.amberAccent,
                  Icons.show_chart_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  AppStrings.get('newUsers', locale),
                  newUsers.toString(),
                  AppStrings.get('last30Days', locale),
                  Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInsightCard(
                  AppStrings.get('recentlyActive', locale),
                  recentActiveUsers.toString(),
                  AppStrings.get('last7Days', locale),
                  Colors.cyanAccent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRetentionCard(
                  locale,
                  retentionRate,
                  retainedUsers,
                  totalUsers,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildRoleDistribution(
            adminCount,
            barberCount,
            regularUserCount,
            totalUsers,
            locale,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.get('elitePerformers', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...topPerformers.map((user) => _buildPerformerItem(user, locale)),
          const SizedBox(height: 16),
          Text(
            AppStrings.get('recentActivity', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._buildRecentActivity(allUsers, locale),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon, {
    bool isSmall = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              if (!isSmall)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Icon(icon, color: color, size: 16)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: isSmall ? 9 : 10,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRetentionCard(
    String locale,
    double rate,
    int retained,
    int total,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.get('retentionRate', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${rate.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: rate / 100,
            backgroundColor: AppColors.border,
            color: AppColors.textPrimary,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 8),
          Text(
            '$retained / $total ${AppStrings.get('usersRetained', locale)}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleDistribution(
    int admin,
    int barber,
    int regular,
    int total,
    String locale,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.get('roleDistribution', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildRoleBar(
            'Admin',
            admin,
            total,
            Colors.redAccent,
            Icons.security,
            locale,
          ),
          const SizedBox(height: 16),
          _buildRoleBar(
            'Barber',
            barber,
            total,
            Colors.blueAccent,
            Icons.content_cut,
            locale,
          ),
          const SizedBox(height: 16),
          _buildRoleBar(
            AppStrings.get('regularUsers', locale),
            regular,
            total,
            Colors.greenAccent,
            Icons.person,
            locale,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBar(
    String label,
    int count,
    int total,
    Color color,
    IconData icon,
    String locale,
  ) {
    final percentage = total > 0 ? (count / total * 100) : 0.0;
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '($count)',
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: AppColors.border,
            color: color,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformerItem(dynamic user, String locale) {
    final roleColor = user.role == 'admin'
        ? Colors.redAccent
        : user.role == 'barber'
            ? Colors.blueAccent
            : Colors.greenAccent;
    final daysSinceLogin = DateTime.now().difference(user.lastSignedIn).inDays;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: roleColor.withOpacity(0.2),
            child: Text(
              user.name?.isNotEmpty == true
                  ? user.name![0].toUpperCase()
                  : '?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: roleColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? user.email ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${user.getRoleDisplay(locale)} • Joined ${user.createdAt.year}-${user.createdAt.month}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$daysSinceLogin ${AppStrings.get('daysAgo', locale)}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              Text(
                user.lastSignedIn.day == DateTime.now().day
                    ? AppStrings.get('today', locale)
                    : user.lastSignedIn.day == DateTime.now().day - 1
                        ? AppStrings.get('yesterday', locale)
                        : '${user.lastSignedIn.month}/${user.lastSignedIn.day}',
                style: const TextStyle(
                  color: AppColors.accentGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRecentActivity(List<dynamic> users, String locale) {
    final sortedUsers = users.toList()
      ..sort((a, b) => b.lastSignedIn.compareTo(a.lastSignedIn));
    final recent = sortedUsers.take(5).toList();

    return recent.map((user) {
      final isNew = DateTime.now().difference(user.createdAt).inDays <= 7;
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isNew ? Colors.greenAccent : AppColors.textSecondary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isNew
                        ? '${AppStrings.get('newUserRegistered', locale)}: ${user.name ?? user.email}'
                        : '${user.name ?? user.email} ${AppStrings.get('lastLogin', locale)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${user.getRoleDisplay(locale)} • ${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              DateTime.now().difference(user.lastSignedIn).inDays == 0
                  ? AppStrings.get('today', locale)
                  : '${DateTime.now().difference(user.lastSignedIn).inDays} ${AppStrings.get('daysAgo', locale)}',
              style: const TextStyle(
                color: Colors.white24,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

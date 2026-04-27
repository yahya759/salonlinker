import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../cubit/locale_cubit.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onNavTap;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onNavTap,
  });

  static const Map<String, IconData> _icons = {
    'dashboard': Icons.grid_view_rounded,
    'calendar_today': Icons.calendar_today_outlined,
    'people': Icons.people_outline,
    'content_cut': Icons.content_cut_outlined,
    'bar_chart': Icons.show_chart_outlined,
    'campaign': Icons.campaign_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state is LocaleChanged
        ? (context.watch<LocaleCubit>().state as LocaleChanged).locale
        : 'ar';

    return Container(
      width: 210,
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.content_cut,
                    color: AppColors.textPrimary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get('appName', locale).split(' ').first,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (AppStrings.get('appName', locale).split(' ').length > 1)
                      Text(
                        AppStrings.get('appName', locale).split(' ').last,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    Text(
                      AppStrings.get('masterAdmin', locale),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ...List.generate(AppStrings.navItems.length, (i) {
            final isSelected = i == selectedIndex;
            final item = AppStrings.navItems[i];
            return NavItem(
              label: item[locale] ?? item['en']!,
              icon: _icons[item['icon']]!,
              isSelected: isSelected,
              locale: locale,
              onTap: () => onNavTap(i),
            );
          }),
          const Spacer(),
          BottomNavItem(
            icon: Icons.help_outline,
            label: AppStrings.get('support', locale),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final String locale;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.locale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sidebarActive : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary.withOpacity(0.5),
              size: 16,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary.withOpacity(0.5),
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const BottomNavItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 15),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

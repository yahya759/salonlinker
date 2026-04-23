import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../cubit/locale_cubit.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.watch<LocaleCubit>();
    final locale = localeCubit.state is LocaleChanged
        ? (localeCubit.state as LocaleChanged).locale
        : 'ar';

    final isRtl = locale == 'ar';

    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Text(
            AppStrings.get('salonName', locale),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: AppColors.textMuted, size: 16),
          const SizedBox(width: 4),
          Text(
            AppStrings.get('dashboard', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textMuted, size: 16),
          Text(
            AppStrings.get('todaysBookings', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          const TopBarIcon(icon: Icons.refresh_rounded),
          const SizedBox(width: 8),
          const TopBarIcon(icon: Icons.notifications_none_rounded),
          const SizedBox(width: 8),
          _LangToggle(
            locale: locale,
            onToggle: () => localeCubit.toggleLocale(),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.pending,
            child: const Icon(
              Icons.person,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class TopBarIcon extends StatelessWidget {
  final IconData icon;
  const TopBarIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, color: AppColors.textSecondary, size: 17),
    );
  }
}

class _LangToggle extends StatelessWidget {
  final String locale;
  final VoidCallback onToggle;

  const _LangToggle({required this.locale, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, color: AppColors.textSecondary, size: 16),
            const SizedBox(width: 4),
            Text(
              locale == 'ar' ? 'ع' : 'EN',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

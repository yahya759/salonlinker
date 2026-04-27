import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/barber_model.dart';
import '../cubit/locale_cubit.dart';

class OnDutyCard extends StatelessWidget {
  final List<Barber> barbers;

  const OnDutyCard({super.key, required this.barbers});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state is LocaleChanged
        ? (context.watch<LocaleCubit>().state as LocaleChanged).locale
        : 'ar';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.get('onDutyToday', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 8,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 75,
                height: 28,
                child: Stack(
                  children: [
                    for (int i = 0; i < barbers.take(3).length; i++)
                      StaffAvatar(
                        offset: i * 18.0,
                        color: _getAvatarColor(i),
                        imageUrl: null,
                      ),
                    if (barbers.length > 3)
                      Positioned(
                        left: 54,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.sidebarActive,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.bg, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              '+${barbers.length - 3}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.get('manageStaff', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      const Color(0xFF4A6FA5),
      const Color(0xFF6A5ACD),
      const Color(0xFF2E8B57),
    ];
    return colors[index % colors.length];
  }
}

class StaffAvatar extends StatelessWidget {
  final double offset;
  final Color color;
  final String? imageUrl;

  const StaffAvatar({
    super.key,
    required this.offset,
    required this.color,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.bg, width: 2),
          image: imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageUrl == null
            ? const Icon(Icons.person, color: Colors.white54, size: 16)
            : null,
      ),
    );
  }
}

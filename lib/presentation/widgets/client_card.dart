import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ClientCard extends StatefulWidget {
  final dynamic user;
  final String locale;

  const ClientCard({super.key, required this.user, required this.locale});

  @override
  State<ClientCard> createState() => _ClientCardState();
}

class _ClientCardState extends State<ClientCard> {
  String _getRoleText() {
    final role = widget.user.role;
    if (role == 'admin') return AppStrings.get('adminRole', widget.locale);
    if (role == 'barber') return AppStrings.get('barberRole', widget.locale);
    return AppStrings.get('userRole', widget.locale);
  }

  Color _getRoleColor() {
    final role = widget.user.role;
    if (role == 'admin') return Colors.redAccent;
    if (role == 'barber') return Colors.blueAccent;
    return Colors.greenAccent;
  }

  String _getMemberSince() {
    if (widget.user.createdAt == null) return 'N/A';
    final date = widget.user.createdAt;
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  String _getLastLogin() {
    if (widget.user.lastSignedIn == null) return 'N/A';
    final date = widget.user.lastSignedIn;
    if (date.day == DateTime.now().day) {
      return AppStrings.get('today', widget.locale);
    }
    return '${date.month}/${date.day}';
  }

  String _getInitial() {
    if (widget.user.name?.isNotEmpty == true) {
      return widget.user.name![0].toUpperCase();
    }
    return '?';
  }

  String _getDisplayName() {
    return widget.user.name ?? widget.user.email ?? 'Unknown User';
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 9,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleText = _getRoleText();
    final roleColor = _getRoleColor();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.textSecondary,
                child: Text(
                  _getInitial(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.bg,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _getDisplayName(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: roleColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            roleText,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: roleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.user.email ?? 'No email',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              _buildStat(
                AppStrings.get('memberSince', widget.locale),
                _getMemberSince(),
              ),
              const SizedBox(width: 40),
              _buildStat(
                AppStrings.get('lastLogin', widget.locale),
                _getLastLogin(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ClientSearchBar extends StatefulWidget {
  final String locale;
  final Function(String) onSearchChanged;

  const ClientSearchBar({
    super.key,
    required this.locale,
    required this.onSearchChanged,
  });

  @override
  State<ClientSearchBar> createState() => _ClientSearchBarState();
}

class _ClientSearchBarState extends State<ClientSearchBar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.get('clientManagement', widget.locale),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.get('searchDatabase', widget.locale),
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                icon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}

class ClientFilterBar extends StatelessWidget {
  final String locale;

  const ClientFilterBar({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildFilterChip(AppStrings.get('statusAll', locale), true),
        const SizedBox(width: 12),
        _buildFilterChip(AppStrings.get('sortLastVisit', locale), false),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white10 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class ClientDirectoryHeader extends StatelessWidget {
  final String locale;

  const ClientDirectoryHeader({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get('clientDirectory', locale),
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 300,
          child: Text(
            AppStrings.get('managingClients', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

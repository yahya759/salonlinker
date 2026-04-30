import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/offer_model.dart';
import '../cubit/offer_cubit.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;
  final String locale;

  const OfferCard({super.key, required this.offer, required this.locale});

  String _getStatusText() {
    if (offer.status == OfferStatus.active) {
      return AppStrings.get('confirmed', locale);
    }
    if (offer.status == OfferStatus.pending) {
      return AppStrings.get('pending', locale);
    }
    return 'EXPIRED';
  }

  String _getTargetText() {
    switch (offer.targetAudience) {
      case TargetAudience.all:
        return 'All';
      case TargetAudience.newClients:
        return 'New';
      case TargetAudience.vip:
        return 'VIP';
    }
  }

  String _getValueSuffix() {
    return offer.valueType == OfferValueType.percentage ? '%' : '\$';
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Delete ${offer.title}?',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              debugPrint('>>> [DELETE] Deleting offer: ${offer.id}');
              context.read<OfferCubit>().deleteOffer(offer.id);
              Navigator.pop(ctx);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: offer.title);
    final descriptionController = TextEditingController(
      text: offer.description ?? '',
    );
    final valueController = TextEditingController(text: offer.value);
    String valueType = offer.valueType == OfferValueType.percentage
        ? 'percentage'
        : 'fixed';
    String targetAudience = offer.targetAudience == TargetAudience.all
        ? 'all'
        : offer.targetAudience == TargetAudience.newClients
            ? 'new_clients'
            : 'vip';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Edit Offer',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration(label: 'Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: valueController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration(label: 'Value'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: valueType,
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration(label: 'Value Type'),
                items: const [
                  DropdownMenuItem(value: 'fixed', child: Text('Fixed \$')),
                  DropdownMenuItem(
                    value: 'percentage',
                    child: Text('Percentage %'),
                  ),
                ],
                onChanged: (v) => valueType = v!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: targetAudience,
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration(label: 'Target'),
                items: const [
                  DropdownMenuItem(
                    value: 'all',
                    child: Text('All Clients'),
                  ),
                  DropdownMenuItem(
                    value: 'new_clients',
                    child: Text('New Clients'),
                  ),
                  DropdownMenuItem(value: 'vip', child: Text('VIP')),
                ],
                onChanged: (v) => targetAudience = v!,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: AppColors.textPrimary),
                maxLines: 3,
                decoration: _inputDecoration(label: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final data = {
                'title': titleController.text,
                'description': descriptionController.text,
                'value': valueController.text,
                'value_type': valueType,
                'targetaudience': targetAudience,
              };
              context.read<OfferCubit>().updateOffer(offer.id, data);
              Navigator.pop(ctx);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.bg,
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusText = _getStatusText();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: offer.imageUrl != null
                    ? Image.network(offer.imageUrl!, fit: BoxFit.cover)
                    : const Icon(
                        Icons.image,
                        color: AppColors.border,
                        size: 48,
                      ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      offer.value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        _getValueSuffix(),
                        style: const TextStyle(
                          fontSize: 8,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  offer.description ?? '',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getTargetText(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _showDeleteDialog(context),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

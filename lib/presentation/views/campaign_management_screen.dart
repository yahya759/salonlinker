import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/offer_model.dart';
import '../../data/repositories/offer_repository.dart';
import '../cubit/locale_cubit.dart';
import '../cubit/offer_cubit.dart';

class CampaignManagementScreen extends StatelessWidget {
  final String locale;

  const CampaignManagementScreen({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 40),
            _buildCampaignTitleSection(),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 350, child: NewOfferForm(locale: locale)),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildActiveCurationsHeader(),
                      const SizedBox(height: 24),
                      const ActiveOffersGrid(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.get('nocturnalAtelier', locale),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.5,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.notifications_none,
          color: AppColors.textSecondary,
          size: 20,
        ),
        const SizedBox(width: 20),
        const Icon(
          Icons.settings_outlined,
          color: AppColors.textSecondary,
          size: 20,
        ),
        const SizedBox(width: 20),
        const CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildCampaignTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get('campaignManagement', locale),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 500,
          child: Text(
            AppStrings.get('campaignDescription', locale),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveCurationsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.get('activeCurations', locale),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        BlocBuilder<OfferCubit, OfferState>(
          builder: (context, state) {
            final activeCount = state is OfferLoaded
                ? state.activeOffers.length
                : 0;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 3,
                    backgroundColor: AppColors.accentGreen,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${AppStrings.get('live', locale)} ($activeCount)',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class NewOfferForm extends StatefulWidget {
  final String locale;

  const NewOfferForm({super.key, required this.locale});

  @override
  State<NewOfferForm> createState() => _NewOfferFormState();
}

class _NewOfferFormState extends State<NewOfferForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  String _valueType = 'fixed';
  String _targetAudience = 'all';
  XFile? _selectedImage;
  String? _imageUrl;
  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _createOffer() async {
    if (_titleController.text.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    String? imageUrl;
    if (_selectedImage != null) {
      try {
        final repository = OfferRepository();
        imageUrl = await repository.uploadImage(_selectedImage!);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('فشل في رفع الصورة: $e')));
        setState(() {
          _isUploading = false;
        });
        return;
      }
    }

    final offer = Offer(
      id: '',
      title: _titleController.text,
      description: _descriptionController.text,
      imageUrl: imageUrl,
      value: _valueController.text,
      valueType: _valueType == 'percentage'
          ? OfferValueType.percentage
          : OfferValueType.fixed,
      targetAudience: _targetAudience == 'all'
          ? TargetAudience.all
          : _targetAudience == 'new_clients'
          ? TargetAudience.newClients
          : TargetAudience.vip,
      status: OfferStatus.pending,
      isActive: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await context.read<OfferCubit>().createOffer(offer);

      _titleController.clear();
      _descriptionController.clear();
      _valueController.clear();
      setState(() {
        _selectedImage = null;
        _imageUrl = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل في إنشاء العرض: $e')));
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const Icon(
                Icons.add_circle_outline,
                size: 20,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.get('newCampaign', widget.locale),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildLabel(AppStrings.get('campaignName', widget.locale)),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: AppStrings.get('campaignNameHint', widget.locale),
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildLabel(AppStrings.get('campaignVisual', widget.locale)),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_selectedImage!.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          color: AppColors.textSecondary,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.get('uploadImage', widget.locale),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(AppStrings.get('value', widget.locale)),
                    TextField(
                      controller: _valueController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: '\$25 / 20%',
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: AppColors.bg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(AppStrings.get('target', widget.locale)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _targetAudience,
                          isExpanded: true,
                          dropdownColor: AppColors.surface,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text(
                                AppStrings.get('allClients', widget.locale),
                              ),
                            ),
                            const DropdownMenuItem(
                              value: 'new_clients',
                              child: Text('New Clients'),
                            ),
                            const DropdownMenuItem(
                              value: 'vip',
                              child: Text('VIP'),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => _targetAudience = v!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildLabel(AppStrings.get('shortDescription', widget.locale)),
          TextField(
            controller: _descriptionController,
            style: const TextStyle(color: AppColors.textPrimary),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: AppStrings.get('descriptionHint', widget.locale),
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isUploading ? null : _createOffer,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textPrimary,
              foregroundColor: AppColors.bg,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isUploading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    AppStrings.get('createCampaign', widget.locale),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class ActiveOffersGrid extends StatelessWidget {
  const ActiveOffersGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state is LocaleChanged
        ? (context.watch<LocaleCubit>().state as LocaleChanged).locale
        : 'ar';

    return BlocBuilder<OfferCubit, OfferState>(
      builder: (context, state) {
        if (state is OfferLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is OfferError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is OfferLoaded) {
          final offers = state.offers;

          if (offers.isEmpty) {
            return Center(
              child: Text(
                AppStrings.get('noOffers', locale),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < offers.length; i += 2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: OfferCard(
                            offer: offers[i],
                            locale:
                                context.watch<LocaleCubit>().state
                                    is LocaleChanged
                                ? (context.watch<LocaleCubit>().state
                                          as LocaleChanged)
                                      .locale
                                : 'ar',
                          ),
                        ),
                        if (i + 1 < offers.length) ...[
                          const SizedBox(width: 24),
                          Expanded(
                            child: OfferCard(
                              offer: offers[i + 1],
                              locale:
                                  context.watch<LocaleCubit>().state
                                      is LocaleChanged
                                  ? (context.watch<LocaleCubit>().state
                                            as LocaleChanged)
                                        .locale
                                  : 'ar',
                            ),
                          ),
                        ] else
                          const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class OfferCard extends StatelessWidget {
  final Offer offer;
  final String locale;

  const OfferCard({super.key, required this.offer, required this.locale});

  @override
  Widget build(BuildContext context) {
    final statusText = offer.status == OfferStatus.active
        ? AppStrings.get('confirmed', locale)
        : offer.status == OfferStatus.pending
        ? AppStrings.get('pending', locale)
        : 'EXPIRED';

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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                        offer.valueType == OfferValueType.percentage
                            ? '%'
                            : '\$',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        offer.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Switch(
                      value: offer.isActive,
                      onChanged: (v) => context
                          .read<OfferCubit>()
                          .toggleOfferStatus(offer.id, v),
                      activeThumbColor: AppColors.textPrimary,
                      activeTrackColor: AppColors.accentGreen.withOpacity(0.5),
                    ),
                  ],
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
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '+12',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
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
              context.read<OfferCubit>().deleteOffer(offer.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

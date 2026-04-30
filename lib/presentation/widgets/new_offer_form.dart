import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_selector/file_selector.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/offer_model.dart';
import '../../../data/repositories/offer_repository.dart';
import '../cubit/offer_cubit.dart';

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
    debugPrint('>>> [IMAGE_PICKER] Starting image selection...');
    const typeGroup = XTypeGroup(
      label: 'Images',
      extensions: ['jpg', 'jpeg', 'png', 'webp'],
    );
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    debugPrint('>>> [IMAGE_PICKER] File selected: ${file?.name}');
    debugPrint('>>> [IMAGE_PICKER] File path: ${file?.path}');
    if (file != null) {
      setState(() {
        _selectedImage = file;
      });
      debugPrint('>>> [IMAGE_PICKER] Image state updated');
    } else {
      debugPrint('>>> [IMAGE_PICKER] No file selected or dialog cancelled');
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في رفع الصورة: $e')),
        );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في إنشاء العرض: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
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
            decoration: _inputDecoration(
              hintText: AppStrings.get('campaignNameHint', widget.locale),
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
                      child: kIsWeb
                          ? Image.network(
                              _selectedImage!.path,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint(
                                  '>>> [IMAGE_PICKER] Web image error: $error',
                                );
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: AppColors.textSecondary,
                                    size: 32,
                                  ),
                                );
                              },
                            )
                          : Image.file(
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
                      decoration: _inputDecoration(hintText: '\$25 / 20%'),
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
            decoration: _inputDecoration(
              hintText: AppStrings.get('descriptionHint', widget.locale),
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
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
}

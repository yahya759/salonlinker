import 'package:file_selector/file_selector.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/offer_model.dart';
import '../../core/supabase/supabase_config.dart';

class OfferRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Offer>> getOffers() async {
    debugPrint('>>> [REPO] getOffers called');
    final response = await _client.from('offers').select();
    debugPrint('>>> [REPO] getOffers response count: ${(response as List).length}');
    return (response as List).map((e) => Offer.fromMap(e)).toList();
  }

  Future<List<Offer>> getActiveOffers() async {
    final response = await _client
        .from('offers')
        .select()
        .eq('is_active', true);
    return (response as List).map((e) => Offer.fromMap(e)).toList();
  }

  Future<Offer?> getOfferById(String id) async {
    final response = await _client
        .from('offers')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (response == null) return null;
    return Offer.fromMap(response);
  }

  Future<void> createOffer(Offer offer) async {
    final map = offer.toMap();
    map.remove('id');
    await _client.from('offers').insert(map);
  }

  Future<void> updateOffer(String id, Map<String, dynamic> data) async {
    debugPrint('>>> Repository updateOffer called with id: $id');
    debugPrint('>>> Data to update: $data');
    if (id.isEmpty) {
      debugPrint('ERROR: ID is empty!');
      return;
    }
    try {
      await _client.from('offers').update(data).eq('id', id);
      debugPrint('>>> UPDATE COMPLETED SUCCESSFULLY');
    } catch (e) {
      debugPrint('>>> Update exception: $e');
      rethrow;
    }
  }

  Future<void> deleteOffer(String id) async {
    debugPrint('>>> [REPO] deleteOffer called - id: $id');
    await _client.from('offers').delete().eq('id', id);
    debugPrint('>>> [REPO] deleteOffer completed');
  }

  Future<void> toggleOfferStatus(String id, bool isActive) async {
    debugPrint('>>> [REPO] toggleOfferStatus called - id: $id, isActive: $isActive');
    await _client.from('offers').update({'is_active': isActive}).eq('id', id);
    debugPrint('>>> [REPO] toggleOfferStatus completed');
  }

  Future<String?> uploadImage(XFile imageFile) async {
    try {
      debugPrint('Starting image upload...');
      debugPrint('File name: ${imageFile.name}');
      debugPrint('File path: ${imageFile.path}');
      
      final fileExt = imageFile.name.split('.').last;
      debugPrint('File extension: $fileExt');
      
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'offers/$fileName';
      debugPrint('Target path: $filePath');

      // Read bytes directly from XFile (works with blob URLs)
      final bytes = await imageFile.readAsBytes();
      debugPrint('File size: ${bytes.length} bytes');

      debugPrint('Uploading to Supabase storage...');
      final response = await _client.storage
          .from('image')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: 'image/$fileExt'),
          );

      debugPrint('Upload response: $response');
      
      if (response.isNotEmpty) {
        final imageUrl = _client.storage.from('image').getPublicUrl(filePath);
        debugPrint('Image URL: $imageUrl');
        return imageUrl;
      }
      debugPrint('Upload failed - empty response');
      return null;
    } catch (e, stack) {
      debugPrint('Upload error: $e');
      debugPrint('Stack trace: $stack');
      rethrow;
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      // Extract file path from URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final filePath = pathSegments.sublist(1).join('/'); // Remove bucket name

      await _client.storage.from('image').remove([filePath]);
    } catch (e) {
      // Ignore errors when deleting images
    }
  }
}

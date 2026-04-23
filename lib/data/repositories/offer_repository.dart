import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/offer_model.dart';
import '../../core/supabase/supabase_config.dart';

class OfferRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Offer>> getOffers() async {
    final response = await _client.from('offers').select();
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
    await _client.from('offers').update(data).eq('id', id);
  }

  Future<void> deleteOffer(String id) async {
    await _client.from('offers').delete().eq('id', id);
  }

  Future<void> toggleOfferStatus(String id, bool isActive) async {
    await _client.from('offers').update({'is_active': isActive}).eq('id', id);
  }

  Future<String?> uploadImage(XFile imageFile) async {
    try {
      final fileExt = imageFile.name.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'offers/$fileName';

      final file = File(imageFile.path);
      final bytes = await file.readAsBytes();

      final response = await _client.storage
          .from('image')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: 'image/$fileExt'),
          );

      if (response.isNotEmpty) {
        final imageUrl = _client.storage.from('image').getPublicUrl(filePath);
        return imageUrl;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
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

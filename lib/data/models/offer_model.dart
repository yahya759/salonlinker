enum OfferStatus { active, pending, expired }

enum OfferValueType { percentage, fixed }

enum TargetAudience { all, newClients, vip }

class Offer {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String value;
  final OfferValueType valueType;
  final TargetAudience targetAudience;
  final OfferStatus status;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Offer({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.value,
    required this.valueType,
    required this.targetAudience,
    required this.status,
    required this.isActive,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Offer.fromMap(Map<String, dynamic> map) {
    try {
      return Offer(
        id: map['id']?.toString() ?? '',
        title: map['title']?.toString() ?? '',
        description: map['description']?.toString(),
        imageUrl: map['image_url']?.toString(),
        value: map['value']?.toString() ?? '',
        valueType: map['value_type'] == 'percentage'
            ? OfferValueType.percentage
            : OfferValueType.fixed,
        targetAudience: _parseTargetAudience(map['targetaudience']?.toString()),
        status: _parseStatus(map['status']?.toString()),
        isActive: map['is_active'] ?? false,
        startDate: map['start_date'] != null
            ? DateTime.tryParse(map['start_date'].toString())
            : null,
        endDate: map['end_date'] != null
            ? DateTime.tryParse(map['end_date'].toString())
            : null,
        createdAt:
            DateTime.tryParse(map['created_at']?.toString() ?? '') ??
            DateTime.now(),
        updatedAt:
            DateTime.tryParse(map['updated_at']?.toString() ?? '') ??
            DateTime.now(),
      );
    } catch (e) {
      // Return a default offer if parsing fails
      return Offer(
        id: '',
        title: 'Error parsing offer',
        value: '',
        valueType: OfferValueType.fixed,
        targetAudience: TargetAudience.all,
        status: OfferStatus.pending,
        isActive: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'value': value,
      'value_type': valueType == OfferValueType.percentage
          ? 'percentage'
          : 'fixed',
      'targetaudience': targetAudience == TargetAudience.all
          ? 'all'
          : targetAudience == TargetAudience.newClients
          ? 'new_clients'
          : 'vip',
      'status': status == OfferStatus.active
          ? 'active'
          : status == OfferStatus.pending
          ? 'pending'
          : 'expired',
      'is_active': isActive,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }

  static OfferStatus _parseStatus(String? status) {
    switch (status) {
      case 'active':
        return OfferStatus.active;
      case 'pending':
        return OfferStatus.pending;
      case 'expired':
        return OfferStatus.expired;
      default:
        return OfferStatus.pending;
    }
  }

  static TargetAudience _parseTargetAudience(String? audience) {
    switch (audience) {
      case 'all':
        return TargetAudience.all;
      case 'new_clients':
        return TargetAudience.newClients;
      case 'vip':
        return TargetAudience.vip;
      default:
        return TargetAudience.all;
    }
  }
}

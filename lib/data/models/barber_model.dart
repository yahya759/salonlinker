import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

class Barber {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final List<String>? specializations;
  final int branchId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Barber({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.specializations,
    required this.branchId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Barber.fromMap(Map<String, dynamic> map) {
    List<String>? specializationsList;
    if (map['specializations'] != null) {
      if (map['specializations'] is List) {
        specializationsList = (map['specializations'] as List)
            .map((e) => e.toString())
            .toList();
      } else if (map['specializations'] is String) {
        specializationsList = [map['specializations']];
      }
    }

    return Barber(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      phone: map['phone'],
      email: map['email'],
      specializations: specializationsList,
      branchId: map['branch_id'] is int
          ? map['branch_id']
          : int.tryParse(map['branch_id']?.toString() ?? '') ?? map['branchid'] ?? 0,
      isActive: map['is_active'] ?? map['isactive'] ?? true,
      createdAt: DateTime.tryParse(map['created_at'] ?? map['createdat'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? map['updatedat'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'branchid': branchId,
      'specializations': specializations,
      'isactive': isActive,
    };
  }

  Color get statusColor => isActive ? Colors.greenAccent : Colors.grey;
  String getStatus(String locale) => isActive
      ? AppStrings.get('onDuty', locale)
      : AppStrings.get('offToday', locale);
}

class Service {
  final int id;
  final String name;
  final String? description;
  final String price;
  final String? duration;
  final String? startTime;
  final String? endTime;
  final String? breakStart;
  final String? breakEnd;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.duration,
    this.startTime,
    this.endTime,
    this.breakStart,
    this.breakEnd,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      price: map['priceusd']?.toString() ?? '0',
      duration: map['durationminutes']?.toString(),
      startTime: map['start_time'],
      endTime: map['end_time'],
      breakStart: map['break_start'],
      breakEnd: map['break_end'],
      isActive: map['is_active'] ?? true,
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'start_time': startTime,
      'end_time': endTime,
      'break_start': breakStart,
      'break_end': breakEnd,
      'is_active': isActive,
    };
  }
}

enum ReservationStatus { pending, confirmed, cancelled }

class Reservation {
  final int id;
  final String clientName;
  final String clientPhone;
  final String serviceName;
  final int? serviceId;
  final DateTime reservationDate;
  final String startTime;
  final String endTime;
  final ReservationStatus status;
  final String? barberName;
  final String? notes;
  final bool isPaid;
  final DateTime createdAt;
  final DateTime updatedAt;

  Reservation({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.serviceName,
    this.serviceId,
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.barberName,
    this.notes,
    required this.isPaid,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reservation.fromMap(Map<String, dynamic> map) {
    // Handle joined data from Supabase (services.name comes as nested object)
    final serviceName = map['services']?['name'] ?? map['service_name'] ?? '';
    final barberName = map['barbers']?['name'] ?? map['barber_name'];

    // Use 'booking_date' column for reservation date
    final dateValue = map['booking_date'];

    DateTime parsedDate;
    if (dateValue is DateTime) {
      parsedDate = dateValue;
    } else if (dateValue is String) {
      parsedDate = DateTime.tryParse(dateValue) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return Reservation(
      id: map['id'] ?? 0,
      clientName: map['client_name'] ?? '',
      clientPhone: map['client_phone'] ?? '',
      serviceName: serviceName.toString(),
      serviceId: map['service_id'],
      reservationDate: parsedDate,
      startTime: map['start_time'] ?? '',
      endTime: map['end_time'] ?? '',
      status: _parseStatus(map['status']),
      barberName: barberName?.toString() ?? map['barber_name'],
      notes: map['notes'],
      isPaid: map['is_paid'] ?? false,
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  static ReservationStatus _parseStatus(String? status) {
    switch (status) {
      case 'confirmed':
        return ReservationStatus.confirmed;
      case 'cancelled':
        return ReservationStatus.cancelled;
      default:
        return ReservationStatus.pending;
    }
  }

  Map<String, dynamic> toMap() {
    final dateStr = reservationDate.toIso8601String().split('T')[0];
    return {
      'client_name': clientName,
      'client_phone': clientPhone,
      'service_name': serviceName,
      'service_id': serviceId,
      'booking_date': dateStr,
      'start_time': startTime,
      'end_time': endTime,
      'status': status.name,
      'barber_name': barberName,
      'notes': notes,
      'is_paid': isPaid,
    };
  }
}

class Branch {
  final int id;
  final String name;
  final String location;
  final String? phone;
  final String? email;
  final String openingTime;
  final String closingTime;
  final String? breakStartTime;
  final String? breakEndTime;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Branch({
    required this.id,
    required this.name,
    required this.location,
    this.phone,
    this.email,
    required this.openingTime,
    required this.closingTime,
    this.breakStartTime,
    this.breakEndTime,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      phone: map['phone'],
      email: map['email'],
      openingTime: map['opening_time']?.toString() ?? map['openingtime']?.toString() ?? '00:00:00',
      closingTime: map['closing_time']?.toString() ?? map['closingtime']?.toString() ?? '00:00:00',
      breakStartTime: map['break_start_time']?.toString() ?? map['breakstarttime']?.toString(),
      breakEndTime: map['break_end_time']?.toString() ?? map['breakendtime']?.toString(),
      isActive: map['is_active'] ?? map['isactive'] ?? true,
      createdAt: DateTime.tryParse(map['created_at'] ?? map['createdat'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? map['updatedat'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'phone': phone,
      'email': email,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'break_start_time': breakStartTime,
      'break_end_time': breakEndTime,
      'is_active': isActive,
    };
  }
}

class TimeSlot {
  final int id;
  final int barberId;
  final String startTime;
  final String endTime;
  final bool isBooked;
  final DateTime createdAt;
  final DateTime updatedAt;

  TimeSlot({
    required this.id,
    required this.barberId,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      id: map['id'] ?? 0,
      barberId: map['barber_id'] ?? 0,
      startTime: map['start_time'] ?? '',
      endTime: map['end_time'] ?? '',
      isBooked: map['is_booked'] ?? false,
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'barber_id': barberId,
      'start_time': startTime,
      'end_time': endTime,
      'is_booked': isBooked,
    };
  }
}

class HaircutImage {
  final int id;
  final String imageUrl;
  final String title;
  final String? description;
  final String? tags;
  final String? category;
  final int? serviceId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  HaircutImage({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.description,
    this.tags,
    this.category,
    this.serviceId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HaircutImage.fromMap(Map<String, dynamic> map) {
    return HaircutImage(
      id: map['id'] ?? 0,
      imageUrl: map['image_url'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      tags: map['tags'],
      category: map['category'],
      serviceId: map['service_id'],
      isActive: map['is_active'] ?? true,
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image_url': imageUrl,
      'title': title,
      'description': description,
      'tags': tags,
      'category': category,
      'service_id': serviceId,
      'is_active': isActive,
    };
  }
}

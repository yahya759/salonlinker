import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

class User {
  final int id;
  final String openId;
  final String? name;
  final String? email;
  final String? loginMethod;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastSignedIn;

  User({
    required this.id,
    required this.openId,
    this.name,
    this.email,
    this.loginMethod,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSignedIn,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      openId: map['open_id'] ?? '',
      name: map['name'],
      email: map['email'],
      loginMethod: map['login_method'],
      role: map['role'] ?? 'user',
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? '') ?? DateTime.now(),
      lastSignedIn:
          DateTime.tryParse(map['last_signed_in'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'open_id': openId,
      'name': name,
      'email': email,
      'login_method': loginMethod,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_signed_in': lastSignedIn.toIso8601String(),
    };
  }

  String getRoleDisplay(String locale) {
    switch (role) {
      case 'admin':
        return AppStrings.get('adminRole', locale);
      case 'barber':
        return AppStrings.get('barberRole', locale);
      case 'user':
      default:
        return AppStrings.get('userRole', locale);
    }
  }

  Color getRoleColor() {
    switch (role) {
      case 'admin':
        return Colors.redAccent;
      case 'barber':
        return Colors.blueAccent;
      case 'user':
      default:
        return Colors.greenAccent;
    }
  }
}

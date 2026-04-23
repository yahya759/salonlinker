import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String _url = 'https://mhruysqylmxkxjdbtfim.supabase.co';
  static const String _anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ocnV5c3F5bG14a3hqZGJ0ZmltIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY3NzE1MjIsImV4cCI6MjA5MjM0NzUyMn0.4ZexQv-uGIoCdIe_ixs4nR6fkbJ7uGM8AJymPG6rhTc';

  static Future<void> init() async {
    await Supabase.initialize(url: _url, anonKey: _anonKey);
  }

  static SupabaseClient get client => SupabaseClient(_url, _anonKey);
}

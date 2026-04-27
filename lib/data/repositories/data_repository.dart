import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/barber_model.dart';
import '../models/user_model.dart';
import '../../core/supabase/supabase_config.dart';

class DataRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  // ============ BARBERS ============
  Future<List<Barber>> getBarbers() async {
    final response = await _client.from('barbers').select();
    return (response as List).map((e) => Barber.fromMap(e)).toList();
  }

  Future<Barber?> getBarberById(int id) async {
    final response = await _client
        .from('barbers')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (response == null) return null;
    return Barber.fromMap(response);
  }

  Future<void> createBarber(Barber barber) async {
    await _client.from('barbers').insert(barber.toMap());
  }

  Future<void> updateBarber(int id, Map<String, dynamic> data) async {
    await _client.from('barbers').update(data).eq('id', id);
  }

  Future<void> deleteBarber(int id) async {
    debugPrint('>>> [REPO] deleteBarber called with id: $id');
    try {
      final result = await _client.from('barbers').delete().eq('id', id).select();
      debugPrint('>>> [REPO] deleteBarber result: $result');
      if (result.isEmpty) {
        debugPrint('>>> [REPO] WARNING: Delete returned empty result - possibly RLS blocked or row not found');
      }
      debugPrint('>>> [REPO] deleteBarber completed');
    } catch (e) {
      debugPrint('>>> [REPO] deleteBarber ERROR: $e');
      rethrow;
    }
  }

  Future<void> toggleBarberAvailability(int id, bool isActive) async {
    await _client.from('barbers').update({'isactive': isActive}).eq('id', id);
  }

  // ============ SERVICES ============
  Future<List<Service>> getServices() async {
    final response = await _client.from('services').select();
    return (response as List).map((e) => Service.fromMap(e)).toList();
  }

  Future<Service?> getServiceById(int id) async {
    final response = await _client
        .from('services')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (response == null) return null;
    return Service.fromMap(response);
  }

  Future<void> createService(Service service) async {
    await _client.from('services').insert(service.toMap());
  }

  Future<void> updateService(int id, Map<String, dynamic> data) async {
    await _client.from('services').update(data).eq('id', id);
  }

  Future<void> deleteService(int id) async {
    await _client.from('services').delete().eq('id', id);
  }

  // ============ RESERVATIONS ============
Future<List<Reservation>> getReservations() async {
    final response = await _client.from('reservations').select('*');
    debugPrint('getReservations: ${response.length} items');
    if (response.isNotEmpty) {
      debugPrint('Sample: ${response.first}');
    }
    return (response as List).map((e) => Reservation.fromMap(e)).toList();
  }

  Future<List<Reservation>> getReservationsByDate(DateTime date) async {
    final dateStr = date.toIso8601String().split('T')[0];
    final response = await _client
        .from('reservations')
        .select('*')
        .eq('booking_date', dateStr);
    debugPrint('getReservationsByDate ($dateStr): ${response.length} items');
    if (response.isNotEmpty) {
      debugPrint('Sample: ${response.first}');
    }
    return (response as List).map((e) => Reservation.fromMap(e)).toList();
  }

  Future<List<Reservation>> getTodayReservations() async {
    return getReservationsByDate(DateTime.now());
  }

  Future<List<Reservation>> getTomorrowReservations() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return getReservationsByDate(tomorrow);
  }

  Future<void> createReservation(Reservation reservation) async {
    await _client.from('reservations').insert(reservation.toMap());
  }

  Future<void> updateReservationStatus(int id, String status) async {
    await _client.from('reservations').update({'status': status}).eq('id', id);
  }

  Future<void> confirmReservation(int id) async {
    await updateReservationStatus(id, 'confirmed');
  }

  Future<void> cancelReservation(int id) async {
    await updateReservationStatus(id, 'cancelled');
  }

  Future<void> deleteReservation(int id) async {
    await _client.from('reservations').delete().eq('id', id);
  }

  // ============ BRANCHES ============
  Future<List<Branch>> getBranches() async {
    final response = await _client.from('branches').select();
    return (response as List).map((e) => Branch.fromMap(e)).toList();
  }

  Future<void> createBranch(Branch branch) async {
    await _client.from('branches').insert(branch.toMap());
  }

  // ============ TIME SLOTS ============
  Future<List<TimeSlot>> getTimeSlotsByBarber(int barberId) async {
    final response = await _client
        .from('time_slots')
        .select()
        .eq('barber_id', barberId);
    return (response as List).map((e) => TimeSlot.fromMap(e)).toList();
  }

  Future<void> createTimeSlot(TimeSlot slot) async {
    await _client.from('time_slots').insert(slot.toMap());
  }

  Future<void> toggleTimeSlotBooking(int id, bool isBooked) async {
    await _client
        .from('time_slots')
        .update({'is_booked': isBooked})
        .eq('id', id);
  }

  // ============ HAIRCUT IMAGES ============
  Future<List<HaircutImage>> getHaircutImages() async {
    final response = await _client.from('haircut_images').select();
    return (response as List).map((e) => HaircutImage.fromMap(e)).toList();
  }

  Future<void> createHaircutImage(HaircutImage image) async {
    await _client.from('haircut_images').insert(image.toMap());
  }

  Future<void> deleteHaircutImage(int id) async {
    await _client.from('haircut_images').delete().eq('id', id);
  }

  // ============ USERS ============
  Future<List<User>> getUsers() async {
    final response = await _client.from('users').select();
    return (response as List).map((e) => User.fromMap(e)).toList();
  }

  Future<User?> getUserById(int id) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (response == null) return null;
    return User.fromMap(response);
  }

  Future<User?> getUserByOpenId(String openId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('open_id', openId)
        .maybeSingle();
    if (response == null) return null;
    return User.fromMap(response);
  }

  Future<void> createUser(User user) async {
    await _client.from('users').insert(user.toMap());
  }

  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    await _client.from('users').update(data).eq('id', id);
  }

  Future<void> deleteUser(int id) async {
    await _client.from('users').delete().eq('id', id);
  }

  Future<void> updateLastSignedIn(int id) async {
    await _client
        .from('users')
        .update({'last_signed_in': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}


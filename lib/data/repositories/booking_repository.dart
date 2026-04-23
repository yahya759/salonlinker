import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking_model.dart';
import '../../core/supabase/supabase_config.dart';

class BookingRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Booking>> getBookings() async {
    final response = await _client.from('bookings').select();
    return (response as List)
        .map(
          (e) => Booking(
            clientName: e['client_name'] ?? '',
            service: e['service'] ?? '',
            stylist: e['stylist'] ?? '',
            schedule: e['schedule'] ?? '',
            status: e['status'] == 'confirmed'
                ? BookingStatus.confirmed
                : BookingStatus.pending,
          ),
        )
        .toList();
  }

  Future<void> addBooking(Booking booking) async {
    await _client.from('bookings').insert({
      'client_name': booking.clientName,
      'service': booking.service,
      'stylist': booking.stylist,
      'schedule': booking.schedule,
      'status': booking.status == BookingStatus.confirmed
          ? 'confirmed'
          : 'pending',
    });
  }

  Future<void> updateBookingStatus(String id, String status) async {
    await _client.from('bookings').update({'status': status}).eq('id', id);
  }
}

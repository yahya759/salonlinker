enum BookingStatus { confirmed, pending }

class Booking {
  final String clientName;
  final String service;
  final String stylist;
  final String schedule;
  final BookingStatus status;
  final String? avatarInitials;

  const Booking({
    required this.clientName,
    required this.service,
    required this.stylist,
    required this.schedule,
    required this.status,
    this.avatarInitials,
  });

  Booking copyWith({
    String? clientName,
    String? service,
    String? stylist,
    String? schedule,
    BookingStatus? status,
    String? avatarInitials,
  }) {
    return Booking(
      clientName: clientName ?? this.clientName,
      service: service ?? this.service,
      stylist: stylist ?? this.stylist,
      schedule: schedule ?? this.schedule,
      status: status ?? this.status,
      avatarInitials: avatarInitials ?? this.avatarInitials,
    );
  }
}

class LiveActivity {
  final String text;
  const LiveActivity(this.text);
}

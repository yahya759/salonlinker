import '../../data/models/booking_model.dart';

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoaded extends DashboardState {
  final List<Booking> bookings;
  final int selectedNavIndex;
  final bool showToday;

  const DashboardLoaded({
    required this.bookings,
    this.selectedNavIndex = 0,
    this.showToday = true,
  });

  DashboardLoaded copyWith({
    List<Booking>? bookings,
    int? selectedNavIndex,
    bool? showToday,
  }) {
    return DashboardLoaded(
      bookings: bookings ?? this.bookings,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      showToday: showToday ?? this.showToday,
    );
  }
}

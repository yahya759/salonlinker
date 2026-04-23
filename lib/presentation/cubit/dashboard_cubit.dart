import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/booking_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final BookingRepository _repository;
  int _selectedNavIndex = 0;

  DashboardCubit({BookingRepository? repository})
    : _repository = repository ?? BookingRepository(),
      super(const DashboardInitial());

  int get selectedNavIndex => _selectedNavIndex;

  Future<void> loadDashboard() async {
    try {
      final bookings = await _repository.getBookings();
      emit(
        DashboardLoaded(
          bookings: bookings,
          selectedNavIndex: _selectedNavIndex,
        ),
      );
    } catch (e) {
      emit(
        DashboardLoaded(
          bookings: const [],
          selectedNavIndex: _selectedNavIndex,
        ),
      );
    }
  }

  void selectNavItem(int index) {
    _selectedNavIndex = index;
    final currentState = state;
    if (currentState is DashboardLoaded) {
      emit(currentState.copyWith(selectedNavIndex: index));
    } else {
      emit(DashboardLoaded(bookings: const [], selectedNavIndex: index));
    }
  }

  void toggleTodayTomorrow(bool showToday) {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      emit(currentState.copyWith(showToday: showToday));
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/barber_model.dart';
import '../../data/models/offer_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/data_repository.dart';
import '../../data/repositories/offer_repository.dart';

void debugLog(String message) {
  debugPrint('>>> [APP_CUBIT] $message');
}

abstract class AppState {}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class AppLoaded extends AppState {
  final List<Barber> barbers;
  final List<Reservation> todayReservations;
  final List<Reservation> tomorrowReservations;
  final List<Reservation> allReservations;
  final List<Branch> branches;
  final List<Service> services;
  final List<Offer> offers;
  final List<Offer> activeOffers;
  final List<User> users;
  final int selectedNavIndex;
  final bool showToday;

  AppLoaded({
    required this.barbers,
    required this.todayReservations,
    required this.tomorrowReservations,
    required this.allReservations,
    required this.branches,
    required this.services,
    required this.offers,
    required this.activeOffers,
    required this.users,
    this.selectedNavIndex = 0,
    this.showToday = true,
  });

  AppLoaded copyWith({
    List<Barber>? barbers,
    List<Reservation>? todayReservations,
    List<Reservation>? tomorrowReservations,
    List<Reservation>? allReservations,
    List<Branch>? branches,
    List<Service>? services,
    List<Offer>? offers,
    List<Offer>? activeOffers,
    List<User>? users,
    int? selectedNavIndex,
    bool? showToday,
  }) {
    return AppLoaded(
      barbers: barbers ?? this.barbers,
      todayReservations: todayReservations ?? this.todayReservations,
      tomorrowReservations: tomorrowReservations ?? this.tomorrowReservations,
      allReservations: allReservations ?? this.allReservations,
      branches: branches ?? this.branches,
      services: services ?? this.services,
      offers: offers ?? this.offers,
      activeOffers: activeOffers ?? this.activeOffers,
      users: users ?? this.users,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      showToday: showToday ?? this.showToday,
    );
  }
}

class AppError extends AppState {
  final String message;

  AppError(this.message);
}

class AppCubit extends Cubit<AppState> {
  final DataRepository _dataRepository;
  final OfferRepository _offerRepository;

  AppCubit({DataRepository? dataRepository, OfferRepository? offerRepository})
    : _dataRepository = dataRepository ?? DataRepository(),
      _offerRepository = offerRepository ?? OfferRepository(),
      super(AppInitial());

  Future<void> loadAll() async {
    final currentState = state;
    int currentNavIndex = 0;
    bool currentShowToday = true;
    if (currentState is AppLoaded) {
      currentNavIndex = currentState.selectedNavIndex;
      currentShowToday = currentState.showToday;
    }

    emit(AppLoading());
    debugLog('loadAll: Starting data fetch...');
    try {
      final barbers = await _dataRepository.getBarbers();
      debugLog('loadAll: Got ${barbers.length} barbers');
      final todayReservations = await _dataRepository.getTodayReservations();
      final tomorrowReservations = await _dataRepository
          .getTomorrowReservations();
      final allReservations = await _dataRepository.getReservations();
      final branches = await _dataRepository.getBranches();
      final services = await _dataRepository.getServices();
      final offers = await _offerRepository.getOffers();
      final activeOffers = offers.where((o) => o.isActive).toList();
      debugLog('loadAll: Fetching users...');
      final users = await _dataRepository.getUsers();
      debugLog('loadAll: Got ${users.length} users');
      if (users.isNotEmpty) {
        debugLog('loadAll: First user: ${users.first.name} - ${users.first.email} - ${users.first.role}');
      }

      emit(
        AppLoaded(
          barbers: barbers,
          todayReservations: todayReservations,
          tomorrowReservations: tomorrowReservations,
          allReservations: allReservations,
          branches: branches,
          services: services,
          offers: offers,
          activeOffers: activeOffers,
          users: users,
          selectedNavIndex: currentNavIndex,
          showToday: currentShowToday,
        ),
      );
      debugLog('loadAll: Completed successfully');
    } catch (e) {
      debugLog('loadAll: ERROR - $e');
      emit(AppError(e.toString()));
    }
  }

  void selectNavItem(int index) {
    final currentState = state;
    if (currentState is AppLoaded) {
      emit(currentState.copyWith(selectedNavIndex: index));
    }
  }

  void toggleTodayTomorrow(bool showToday) {
    final currentState = state;
    if (currentState is AppLoaded) {
      emit(currentState.copyWith(showToday: showToday));
    }
  }

  // Barbers
  Future<void> addBarber(Barber barber) async {
    try {
      await _dataRepository.createBarber(barber);
      await loadAll();
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> updateBarber(int id, Map<String, dynamic> data) async {
    try {
      await _dataRepository.updateBarber(id, data);
      await loadAll();
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> deleteBarber(int id) async {
    debugPrint('>>> [CUBIT] deleteBarber called with id: $id');
    try {
      await _dataRepository.deleteBarber(id);
      debugPrint('>>> [CUBIT] deleteBarber repo call succeeded, reloading...');
      await loadAll();
      debugPrint('>>> [CUBIT] deleteBarber completed');
    } catch (e) {
      debugPrint('>>> [CUBIT] deleteBarber error: $e');
      emit(AppError(e.toString()));
    }
  }

  Future<void> toggleBarberAvailability(int id, bool isActive) async {
    try {
      final currentState = state;
      if (currentState is AppLoaded) {
        await _dataRepository.toggleBarberAvailability(id, isActive);
        final updatedBarbers = currentState.barbers.map((b) {
          if (b.id == id) {
            return Barber(
              id: b.id,
              name: b.name,
              phone: b.phone,
              email: b.email,
              specializations: b.specializations,
              branchId: b.branchId,
              isActive: isActive,
              createdAt: b.createdAt,
              updatedAt: DateTime.now(),
            );
          }
          return b;
        }).toList();
        emit(AppLoaded(
          barbers: updatedBarbers,
          todayReservations: currentState.todayReservations,
          tomorrowReservations: currentState.tomorrowReservations,
          allReservations: currentState.allReservations,
          branches: currentState.branches,
          services: currentState.services,
          offers: currentState.offers,
          activeOffers: currentState.activeOffers,
          users: currentState.users,
          selectedNavIndex: currentState.selectedNavIndex,
          showToday: currentState.showToday,
        ));
      }
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  // Reservations
  Future<void> addReservation(Reservation reservation) async {
    try {
      await _dataRepository.createReservation(reservation);
      await loadAll();
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> confirmReservation(int id) async {
    try {
      await _dataRepository.confirmReservation(id);
      await loadAll();
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> cancelReservation(int id) async {
    try {
      await _dataRepository.cancelReservation(id);
      await loadAll();
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  // Offers
  Future<void> addOffer(Offer offer) async {
    try {
      await _offerRepository.createOffer(offer);
      await loadAll();
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> toggleOfferStatus(String id, bool isActive) async {
    try {
      await _offerRepository.toggleOfferStatus(id, isActive);
      await loadAll();
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> deleteOffer(String id) async {
    try {
      await _offerRepository.deleteOffer(id);
      await loadAll();
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }
}

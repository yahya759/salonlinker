import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/barber_model.dart';
import '../../data/models/offer_model.dart';
import '../../data/repositories/data_repository.dart';
import '../../data/repositories/offer_repository.dart';

abstract class AppState {}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class AppLoaded extends AppState {
  final List<Barber> barbers;
  final List<Reservation> todayReservations;
  final List<Reservation> tomorrowReservations;
  final List<Branch> branches;
  final List<Service> services;
  final List<Offer> offers;
  final List<Offer> activeOffers;
  final int selectedNavIndex;
  final bool showToday;

  AppLoaded({
    required this.barbers,
    required this.todayReservations,
    required this.tomorrowReservations,
    required this.branches,
    required this.services,
    required this.offers,
    required this.activeOffers,
    this.selectedNavIndex = 0,
    this.showToday = true,
  });

  AppLoaded copyWith({
    List<Barber>? barbers,
    List<Reservation>? todayReservations,
    List<Reservation>? tomorrowReservations,
    List<Branch>? branches,
    List<Service>? services,
    List<Offer>? offers,
    List<Offer>? activeOffers,
    int? selectedNavIndex,
    bool? showToday,
  }) {
    return AppLoaded(
      barbers: barbers ?? this.barbers,
      todayReservations: todayReservations ?? this.todayReservations,
      tomorrowReservations: tomorrowReservations ?? this.tomorrowReservations,
      branches: branches ?? this.branches,
      services: services ?? this.services,
      offers: offers ?? this.offers,
      activeOffers: activeOffers ?? this.activeOffers,
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
    try {
      final barbers = await _dataRepository.getBarbers();
      final todayReservations = await _dataRepository.getTodayReservations();
      final tomorrowReservations = await _dataRepository
          .getTomorrowReservations();
      final branches = await _dataRepository.getBranches();
      final services = await _dataRepository.getServices();
      final offers = await _offerRepository.getOffers();
      final activeOffers = offers.where((o) => o.isActive).toList();

      emit(
        AppLoaded(
          barbers: barbers,
          todayReservations: todayReservations,
          tomorrowReservations: tomorrowReservations,
          branches: branches,
          services: services,
          offers: offers,
          activeOffers: activeOffers,
          selectedNavIndex: currentNavIndex,
          showToday: currentShowToday,
        ),
      );
    } catch (e) {
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
    try {
      await _dataRepository.deleteBarber(id);
      await loadAll();
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> toggleBarberAvailability(int id, bool isAvailable) async {
    try {
      await _dataRepository.toggleBarberAvailability(id, isAvailable);
      await loadAll();
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

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/offer_model.dart';
import '../../data/repositories/offer_repository.dart';

abstract class OfferState {}

class OfferInitial extends OfferState {}

class OfferLoading extends OfferState {}

class OfferLoaded extends OfferState {
  final List<Offer> offers;
  final List<Offer> activeOffers;

  OfferLoaded({required this.offers, required this.activeOffers});
}

class OfferError extends OfferState {
  final String message;

  OfferError(this.message);
}

class OfferCubit extends Cubit<OfferState> {
  final OfferRepository _repository;

  OfferCubit({OfferRepository? repository})
    : _repository = repository ?? OfferRepository(),
      super(OfferInitial());

  Future<void> loadOffers() async {
    emit(OfferLoading());
    try {
      final offers = await _repository.getOffers();
      final activeOffers = offers.where((o) => o.isActive).toList();
      emit(OfferLoaded(offers: offers, activeOffers: activeOffers));
    } catch (e) {
      // If error, emit empty list instead of error to prevent crash
      emit(OfferLoaded(offers: const [], activeOffers: const []));
    }
  }

  Future<void> createOffer(Offer offer) async {
    try {
      await _repository.createOffer(offer);
      await loadOffers();
    } catch (e) {
      emit(OfferError(e.toString()));
    }
  }

  Future<void> updateOffer(String id, Map<String, dynamic> data) async {
    try {
      debugPrint('Updating offer $id with data: $data');
      await _repository.updateOffer(id, data);
      await loadOffers();
    } catch (e) {
      debugPrint('Update error: $e');
      emit(OfferError(e.toString()));
    }
  }

  Future<void> deleteOffer(String id) async {
    try {
      await _repository.deleteOffer(id);
      await loadOffers();
    } catch (e) {
      emit(OfferError(e.toString()));
    }
  }

  Future<void> toggleOfferStatus(String id, bool isActive) async {
    debugPrint('>>> [CUBIT] toggleOfferStatus called - id: $id, isActive: $isActive');
    try {
      await _repository.toggleOfferStatus(id, isActive);
      debugPrint('>>> [CUBIT] toggleOfferStatus repo call succeeded, reloading...');
      await loadOffers();
      debugPrint('>>> [CUBIT] toggleOfferStatus completed');
    } catch (e) {
      debugPrint('>>> [CUBIT] toggleOfferStatus error: $e');
      emit(OfferError(e.toString()));
    }
  }
}

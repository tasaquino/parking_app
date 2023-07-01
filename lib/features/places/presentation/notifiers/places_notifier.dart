import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/places/data/models/parking_place.dart';
import 'package:parking_app/features/places/domain/places_interactor.dart';
import 'package:parking_app/features/places/presentation/notifiers/places_state.dart';

class PlacesNotifier extends StateNotifier<PlacesState> {
  final PlacesInteractor _interactor;
  PlacesNotifier(this._interactor)
      : super(const PlacesState(state: PlacesPossibleStates.initial));

  Future<void> setInitialState() async {
    state = const PlacesState(state: PlacesPossibleStates.initial);
  }

  Future<void> searchPlaces(double latitude, double longitude) async {
    state = const PlacesState(state: PlacesPossibleStates.loading);
    final places = await _interactor.searchParkingPlaces(latitude, longitude);

    state = places.isNotEmpty
        ? state.copyWith(state: PlacesPossibleStates.loaded, places: places)
        : state.copyWith(state: PlacesPossibleStates.failure);
  }

  Future<void> setPlaceSelected(ParkingPlace place) async {
    final newPlaces = [place, ...state.places.where((p) => p != place)];
    state = state.copyWith(places: newPlaces, selectedPlace: place);
  }
}

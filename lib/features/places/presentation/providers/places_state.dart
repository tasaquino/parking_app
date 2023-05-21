import 'package:equatable/equatable.dart';
import 'package:parking_app/features/places/data/models/parking_place.dart';

enum PlacesPossibleStates {
  initial,
  loading,
  loaded,
  failure,
}

class PlacesState extends Equatable {
  final PlacesPossibleStates state;
  final List<ParkingPlace> places;
  final ParkingPlace? selectedPlace;

  const PlacesState({
    this.state = PlacesPossibleStates.initial,
    this.places = const [],
    this.selectedPlace,
  });

  PlacesState copyWith(
      {PlacesPossibleStates? state,
      List<ParkingPlace>? places,
      ParkingPlace? selectedPlace}) {
    return PlacesState(
        state: state ?? this.state,
        places: places ?? this.places,
        selectedPlace: selectedPlace ?? this.selectedPlace);
  }

  @override
  List<Object?> get props => [places, selectedPlace, state];
}

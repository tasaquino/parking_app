import 'package:parking_app/features/places/data/models/parking_place.dart';
import 'package:parking_app/features/places/data/places_repository.dart';
import 'package:parking_app/features/places/domain/places_interactor.dart';

class PlacesInteractorImpl implements PlacesInteractor {
  final PlacesRepository _repository;
  PlacesInteractorImpl(this._repository);

  @override
  Future<List<ParkingPlace>> searchParkingPlaces(
      double latitude, double longitude) {
    return _repository.searchParkingPlaces(latitude, longitude);
  }
}

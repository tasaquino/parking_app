import 'package:parking_app/features/places/data/models/parking_place.dart';

abstract class PlacesInteractor {
  Future<List<ParkingPlace>> searchParkingPlaces(
      double latitude, double longitude);
}

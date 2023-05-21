import 'package:parking_app/features/places/data/models/parking_place.dart';

abstract class PlacesRepository {
  Future<List<ParkingPlace>> searchParkingPlaces(
      double latitude, double longitude);
}

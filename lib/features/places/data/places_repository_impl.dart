import 'dart:convert';

import 'package:parking_app/features/places/data/models/parking_place.dart';
import 'package:parking_app/features/places/data/places_repository.dart';

import '../../../utils/app_configuration.dart';
import 'package:http/http.dart' as http;

class PlacesRepositoryImpl implements PlacesRepository {
  final http.Client _http;
  PlacesRepositoryImpl(this._http);

  static const String _baseUrlNearBySearch =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?";

  Uri _searchUrl(double latitude, double longitude) {
    const api = "&key=${AppConfiguration.googleApiToken}";

    final location = "location=$latitude,$longitude";

    const type = "&type=parking";
    const rankBy = "&rankby=distance";
    final url =
        Uri.parse(_baseUrlNearBySearch + location + rankBy + type + api);
    return url;
  }

  @override
  Future<List<ParkingPlace>> searchParkingPlaces(
      double latitude, double longitude) async {
    final res = await _http.get(_searchUrl(latitude, longitude));
    final decodedRes = await jsonDecode(res.body) as Map;
    final results = decodedRes['results'] as List;
    final list = _mapToParkingPlaces(results);
    return list;
  }

  List<ParkingPlace> _mapToParkingPlaces(List<dynamic> results) {
    List<ParkingPlace> places = [];
    for (var result in results) {
      Map<String, dynamic> geometry = result["geometry"];
      Map<String, dynamic> location = geometry["location"];
      double? latitude = location["lat"];
      double? longitude = location["lng"];
      String name = result["name"];
      String placeID = result["place_id"];
      String address = result["vicinity"] ?? "";

      places.add(ParkingPlace(
          id: placeID,
          name: name,
          latitude: latitude,
          longitude: longitude,
          address: address));
    }
    return places;
  }
}

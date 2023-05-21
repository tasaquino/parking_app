import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_app/features/places/data/places_repository.dart';
import 'package:parking_app/features/places/data/places_repository_impl.dart';
import 'package:parking_app/utils/app_configuration.dart';

import 'package:http/http.dart' as http;

import '../../user/data/user_repository_test.mocks.dart';
import '../fixtures.dart';

Uri placesSearchUrl(double latitude, double longitude) {
  const api = "&key=${AppConfiguration.googleApiToken}";

  final location = "location=$latitude,$longitude";

  const type = "&type=parking";
  const rankBy = "&rankby=distance";
  final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?$location$rankBy$type$api");
  return url;
}

@GenerateMocks([http.Client])
void main() {
  late PlacesRepository repository;
  late http.Client httpClient;

  setUpAll(() {
    httpClient = MockClient();
    repository = PlacesRepositoryImpl(httpClient);
  });

  group('Places Repository Test', () {
    test('Should fetch places with success', () async {
      double lat = 37.395235;
      double longi = -122.214785;

      when(httpClient.get(placesSearchUrl(lat, longi)))
          .thenAnswer((_) async => http.Response(placesResponse, 200));

      final result = await repository.searchParkingPlaces(lat, longi);
      expect(result, isNotEmpty);
    });
  });
}

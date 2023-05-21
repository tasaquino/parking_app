import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_app/features/places/data/places_repository.dart';
import 'package:parking_app/features/places/data/places_repository_impl.dart';
import 'package:parking_app/features/places/domain/places_interactor.dart';
import 'package:parking_app/features/places/domain/places_interactor_impl.dart';
import 'package:http/http.dart' as http;

import '../../user/data/user_repository_test.mocks.dart';
import '../data/places_repository_test.dart';
import '../fixtures.dart';

@GenerateMocks([http.Client])
void main() {
  late PlacesRepository repository;
  late PlacesInteractor interactor;
  late http.Client httpClient;

  setUpAll(() {
    httpClient = MockClient();
    repository = PlacesRepositoryImpl(httpClient);
    interactor = PlacesInteractorImpl(repository);
  });
  group('Places Interactor Tests', () {
    test('Should fetch places with success', () async {
      double lat = 37.395235;
      double longi = -122.214785;
      when(httpClient.get(placesSearchUrl(lat, longi)))
          .thenAnswer((_) async => http.Response(placesResponse, 200));

      final result = await interactor.searchParkingPlaces(lat, longi);
      expect(result, isNotEmpty);
    });
  });
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:http/http.dart' as http;
import 'package:parking_app/features/parking/data/models/parking.dart';
import 'package:parking_app/features/parking/data/parking_repository.dart';
import 'package:parking_app/features/parking/data/parking_repository_impl.dart';
import 'package:parking_app/features/user/data/user_repository.dart';
import 'package:parking_app/utils/app_configuration.dart';

import 'parking_repository_test.mocks.dart';

const authToken = "some token";
const userID = "some id";

const String response = ''' {
    "12191a71" : 
              {
                "id": "placeID",
                "placeName": "placeName",
                "placeAddress": "placeAddress",
                "vehicleID": "vehicleID",
                "vehicleRegistration": "vehicleRegistration"
              }
    }
    ''';

const Parking parking = Parking(
    placeID: "placeID",
    placeName: "placeName",
    placeAddress: "placeAddress",
    vehicleID: "vehicleID",
    vehicleRegistration: "vehicleRegistration");

Future<Uri> _buildUrl(
    {String? parkingID,
    String? query,
    required String authToken,
    required String userID}) async {
  if (parkingID != null) {
    return Uri.https(
        AppConfiguration.projectUrl,
        'users/$userID/parkings/$parkingID.json${query ?? ""}',
        {'auth': authToken});
  }

  return Uri.https(AppConfiguration.projectUrl,
      'users/$userID/parkings.json?${query ?? ""}', {'auth': authToken});
}

@GenerateMocks([http.Client, UserRepository])
void main() {
  late ParkingRepository repository;
  late UserRepository userRepository;
  late http.Client httpClient;

  setUpAll(() {
    httpClient = MockClient();
    userRepository = MockUserRepository();
    repository = ParkingRepositoryImpl(httpClient, userRepository);
  });

  group('Parkings Repository Test', () {
    test('Should fetch ongoing parking with success', () async {
      final uri = await _buildUrl(
          authToken: authToken,
          userID: userID,
          query: '?orderBy=\"end\"&startAt="0"');
      when(httpClient.get(uri, headers: {
        'Content-Type': 'application/json',
      })).thenAnswer((_) async => http.Response(response, 200));
      when(userRepository.getAuthToken())
          .thenAnswer((realInvocation) => Future.value(authToken));
      when(userRepository.getUserID()).thenAnswer((realInvocation) => userID);

      final result = await repository.getOngoingParking();
      expect(result, isA<Parking>());
    });

    test('Should save parking with success', () async {
      final uri = await _buildUrl(
        authToken: authToken,
        userID: userID,
        parkingID: parking.parkingID,
      );

      when(httpClient.put(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "placeID": parking.placeID,
            "placeName": parking.placeName,
            "placeAddress": parking.placeAddress,
            "vehicleID": parking.vehicleID,
            "vehicleRegistration": parking.vehicleRegistration,
            "start": parking.start?.millisecondsSinceEpoch ?? 0,
            "end": parking.end?.millisecondsSinceEpoch ?? 0,
          }))).thenAnswer((_) async => http.Response('', 200));
      when(userRepository.getAuthToken())
          .thenAnswer((realInvocation) => Future.value("some token"));
      when(userRepository.getUserID())
          .thenAnswer((realInvocation) => "some id");

      final result = await repository.save(parking);
      expect(result, true);
    });

    test('Should update parking with success', () async {
      final uri = await _buildUrl(
        authToken: authToken,
        userID: userID,
        parkingID: parking.parkingID,
      );

      when(httpClient.patch(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "placeID": parking.placeID,
            "placeName": parking.placeName,
            "placeAddress": parking.placeAddress,
            "vehicleID": parking.vehicleID,
            "vehicleRegistration": parking.vehicleRegistration,
            "start": parking.start?.millisecondsSinceEpoch ?? 0,
            "end": parking.end?.millisecondsSinceEpoch ?? 0,
          }))).thenAnswer((_) async => http.Response('', 200));
      when(userRepository.getAuthToken())
          .thenAnswer((realInvocation) => Future.value("some token"));
      when(userRepository.getUserID())
          .thenAnswer((realInvocation) => "some id");

      final result = await repository.update(parking);
      expect(result, true);
    });
  });
}

import 'dart:convert';

import 'package:parking_app/features/user/data/user_repository.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/utils/app_configuration.dart';
import 'package:test/test.dart';
import 'package:parking_app/features/vehicles/data/vehicles_repository.dart';
import 'package:parking_app/features/vehicles/data/vehicles_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'vehicle_repository_test.mocks.dart';

const listOfVehicles = '''{
  "12191a71-6a24-4107-b876-2954f022976c": {
    "id": "12191a71-6a24-4107-b876-2954f022976c",
    "name": "A",
    "registrationNumber": "KKK",
    "selected": false
  },
  "8861d802-c18a-4040-a54a-df74ae4a6b7f": {
    "id": "8861d802-c18a-4040-a54a-df74ae4a6b7f",
    "name": "Ka",
    "registrationNumber": "DQL8457",
    "selected": true
  }
}''';

Future<Uri> buildUri({String? vehicleID}) async {
  if (vehicleID != null) {
    return Uri.https(AppConfiguration.projectUrl,
        'users/some id/vehicles/1.json', {'auth': 'some token'});
  }

  return Uri.https(AppConfiguration.projectUrl, 'users/some id/vehicles.json',
      {'auth': 'some token'});
}

@GenerateMocks([http.Client, UserRepository])
void main() {
  late VehiclesRepository repository;
  late UserRepository userRepository;
  late http.Client httpClient;

  setUpAll(() {
    httpClient = MockClient();
    userRepository = MockUserRepository();
    repository = VehiclesRepositoryImpl(httpClient, userRepository);
  });

  group('Vehicles Repository Test', () {
    test('Should fetch vehicles with success', () async {
      final uri = await buildUri();
      when(httpClient.get(uri, headers: {
        'Content-Type': 'application/json',
      })).thenAnswer((_) async => http.Response(listOfVehicles, 200));
      when(userRepository.getAuthToken())
          .thenAnswer((realInvocation) => Future.value("some token"));
      when(userRepository.getUserID())
          .thenAnswer((realInvocation) => "some id");

      final result = await repository.fetchVehiclesForUser();
      expect(result, isA<List<Vehicle>>());
      expect(result.length, 2);
    });

    test('Should return empty vehicles list when there is server error',
        () async {
      final uri = await buildUri();
      when(httpClient.get(uri, headers: {
        'Content-Type': 'application/json',
      })).thenAnswer((_) async => http.Response(listOfVehicles, 500));
      when(userRepository.getAuthToken())
          .thenAnswer((realInvocation) => Future.value("some token"));
      when(userRepository.getUserID())
          .thenAnswer((realInvocation) => "some id");

      final result = await repository.fetchVehiclesForUser();
      expect(result, isA<List<Vehicle>>());
      expect(result.length, 0);
    });

    test('Should delete vehicle by ID with success', () async {
      final uri = await buildUri(vehicleID: '1');
      when(httpClient.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      )).thenAnswer((_) async => http.Response('', 200));
      when(userRepository.getAuthToken())
          .thenAnswer((realInvocation) => Future.value("some token"));
      when(userRepository.getUserID())
          .thenAnswer((realInvocation) => "some id");

      final result = await repository.deleteVehicle("1");
      expect(result, true);
    });

    test('Should delete vehicle by ID with success', () async {
      final uri = await buildUri(vehicleID: '1');
      when(httpClient.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      )).thenAnswer((_) async => http.Response('', 200));
      when(userRepository.getAuthToken())
          .thenAnswer((realInvocation) => Future.value("some token"));
      when(userRepository.getUserID())
          .thenAnswer((realInvocation) => "some id");

      final result = await repository.deleteVehicle("1");
      expect(result, true);
    });

    test('Should save vehicle with success', () async {
      final uri = await buildUri(vehicleID: '1');
      final vehicle = Vehicle(
          id: '1',
          selected: true,
          registrationNumber: 'abcd1234',
          name: 'myCar');
      when(httpClient.put(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "id": vehicle.id,
            "name": vehicle.name,
            "registrationNumber": vehicle.registrationNumber,
            "selected": vehicle.selected,
          }))).thenAnswer((_) async => http.Response('', 200));
      when(userRepository.getAuthToken())
          .thenAnswer((realInvocation) => Future.value("some token"));
      when(userRepository.getUserID())
          .thenAnswer((realInvocation) => "some id");

      final result = await repository.saveVehicle(vehicle);
      expect(result, true);
    });
    test('Should update vehicle properties with success', () async {
      final uri = await buildUri(vehicleID: '1');
      when(httpClient.patch(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "name": 'newName',
            "registrationNumber": '123456789',
            "selected": false,
          }))).thenAnswer((_) async => http.Response('', 200));
      when(userRepository.getAuthToken())
          .thenAnswer((realInvocation) => Future.value("some token"));
      when(userRepository.getUserID())
          .thenAnswer((realInvocation) => "some id");

      final result = await repository.updateVehicle(
          vehicleID: '1',
          name: 'newName',
          registerNumber: '123456789',
          selected: false);
      expect(result, true);
    });
  });
}

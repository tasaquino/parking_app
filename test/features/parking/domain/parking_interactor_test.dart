import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_app/features/parking/data/models/parking.dart';
import 'package:parking_app/features/parking/data/parking_repository.dart';
import 'package:parking_app/features/parking/domain/parking_interactor.dart';
import 'package:parking_app/features/parking/domain/parking_interactor_impl.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/features/vehicles/data/vehicles_repository.dart';

import '../data/parking_repository_test.dart';
import 'parking_interactor_test.mocks.dart';

final vehicleList = [
  Vehicle(
      id: '1',
      selected: false,
      registrationNumber: 'ABCD1452',
      name: 'Car Name'),
  Vehicle(
      id: '2', selected: true, registrationNumber: 'ABCD1452', name: 'Car Name')
];

@GenerateMocks([ParkingRepository, VehiclesRepository])
void main() {
  late ParkingRepository repository;
  late VehiclesRepository vehiclesRepository;
  late ParkingInteractor interactor;
  setUpAll(() {
    repository = MockParkingRepository();
    vehiclesRepository = MockVehiclesRepository();
    interactor = ParkingInteractorImpl(repository, vehiclesRepository);
  });
  group('Parking Interactor Tests', () {
    test('Should fetch ongoing parking with success', () async {
      when(interactor.getOngoingParking())
          .thenAnswer((realInvocation) async => parking);

      final result = await interactor.getOngoingParking();
      expect(result, isA<Parking>());
    });

    test('Should start parking with success', () async {
      final time = DateTime.now();
      when(repository.save(parking, time: time))
          .thenAnswer((realInvocation) async => true);

      final result = await interactor.startParking(parking, time: time);
      expect(result, true);
    });

    test('Should stop parking with success', () async {
      final time = DateTime.now();
      when(repository.update(parking, time: time))
          .thenAnswer((realInvocation) async => true);

      final result = await interactor.stopParking(parking, time: time);
      expect(result, true);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/features/vehicles/data/vehicles_repository.dart';
import 'package:parking_app/features/vehicles/domain/vehicles_interactor.dart';
import 'package:parking_app/features/vehicles/domain/vehicles_interactor_impl.dart';

import 'vehicles_interactor_test.mocks.dart';

final vehicleList = [
  Vehicle(
      id: '1',
      selected: false,
      registrationNumber: 'ABCD1452',
      name: 'Car Name'),
  Vehicle(
      id: '2', selected: true, registrationNumber: 'ABCD1452', name: 'Car Name')
];

@GenerateMocks([VehiclesRepository])
void main() {
  late VehiclesRepository repository;
  late VehiclesInteractor interactor;
  setUpAll(() {
    repository = MockVehiclesRepository();
    interactor = VehiclesInteractorImpl(repository);
  });
  group('Vehicle Interactor Tests', () {
    test('Should fetch vehicles with success', () async {
      when(repository.fetchVehiclesForUser())
          .thenAnswer((realInvocation) async => vehicleList);

      final result = await interactor.fetchVehiclesForUser();
      expect(result, isA<List<Vehicle>>());
      expect(result.length, vehicleList.length);
      expect(result[0].selected, true);
    });
    test('Should save vehicle with success', () async {
      when(repository.saveVehicle(vehicleList[1]))
          .thenAnswer((realInvocation) async => true);

      final result = await interactor.saveVehicle(vehicleList[1]);
      expect(result, true);
    });
    test('Should update vehicle with success', () async {
      when(repository.updateVehicle(vehicleID: '1', name: "newName"))
          .thenAnswer((realInvocation) async => true);

      final result =
          await interactor.updateVehicle(vehicleID: '1', name: "newName");
      expect(result, true);
    });
    test('Should delete vehicle with success', () async {
      when(repository.deleteVehicle('1'))
          .thenAnswer((realInvocation) async => true);

      final result = await interactor.deleteVehicle('1');
      expect(result, true);
    });
    test('Should select vehicle with success', () async {
      when(repository.fetchVehiclesForUser())
          .thenAnswer((realInvocation) async => vehicleList);
      when(repository.updateVehicle(vehicleID: '1', selected: true))
          .thenAnswer((realInvocation) async => true);
      when(repository.updateVehicle(vehicleID: '2', selected: false))
          .thenAnswer((realInvocation) async => true);

      final result = await interactor.selectVehicle('1', true);
      expect(result, true);
    });

    test('Should update vehicle with success', () async {
      when(repository.fetchVehiclesForUser())
          .thenAnswer((realInvocation) async => vehicleList);
      when(repository.updateVehicle(vehicleID: '1', selected: true))
          .thenAnswer((realInvocation) async => true);
      when(repository.updateVehicle(vehicleID: '2', selected: false))
          .thenAnswer((realInvocation) async => true);

      final result =
          await interactor.updateVehicle(vehicleID: '1', selected: true);
      expect(result, true);
    });
  });
}

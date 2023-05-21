import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/features/vehicles/domain/vehicles_interactor.dart';
import 'package:parking_app/features/vehicles/presentation/providers/detail/vehicle_detail_notifier.dart';
import 'package:parking_app/features/vehicles/presentation/providers/detail/vehicle_detail_states.dart';
import 'package:state_notifier_test/state_notifier_test.dart';
import '../list/vehicle_list_notifier_test.mocks.dart';

@GenerateMocks([VehiclesInteractor])
void main() {
  late VehiclesInteractor interactor;
  late VehicleDetailNotifier notifier;
  Vehicle vehicle = Vehicle(
      id: "id", selected: true, registrationNumber: "abcd", name: "car1");

  const initialState =
      VehicleDetailState(state: VehicleDetailPossibleStates.initial);

  setUpAll(() {
    interactor = MockVehiclesInteractor();
  });

  stateNotifierTest<VehicleDetailNotifier, VehicleDetailState>(
    'Should save vehicle and present proper states',
    build: () {
      notifier = VehicleDetailNotifier(interactor);
      return notifier;
    },
    setUp: () {
      when(interactor.saveVehicle(vehicle))
          .thenAnswer((realInvocation) async => true);
    },
    actions: (notifier) async {
      await notifier.save(vehicle);
    },
    expect: () => [
      initialState.copyWith(state: VehicleDetailPossibleStates.saving),
      initialState.copyWith(state: VehicleDetailPossibleStates.saved),
    ],
  );

  stateNotifierTest<VehicleDetailNotifier, VehicleDetailState>(
    'Should save vehicle and present proper states when there is failure',
    build: () {
      notifier = VehicleDetailNotifier(interactor);
      return notifier;
    },
    setUp: () {
      when(interactor.saveVehicle(vehicle))
          .thenAnswer((realInvocation) async => false);
    },
    actions: (notifier) async {
      await notifier.setInitialState();
      await notifier.save(vehicle);
    },
    expect: () => [
      initialState.copyWith(state: VehicleDetailPossibleStates.saving),
      initialState.copyWith(state: VehicleDetailPossibleStates.failure),
    ],
  );

  stateNotifierTest<VehicleDetailNotifier, VehicleDetailState>(
    'Should update vehicle and present proper states',
    build: () {
      notifier = VehicleDetailNotifier(interactor);
      return notifier;
    },
    setUp: () {
      when(interactor.updateVehicle(vehicleID: "id", name: "new name"))
          .thenAnswer((realInvocation) async => true);
    },
    actions: (notifier) async {
      await notifier.setInitialState();
      await notifier.update(vehicleID: "id", name: "new name");
    },
    expect: () => [
      initialState.copyWith(state: VehicleDetailPossibleStates.saving),
      initialState.copyWith(state: VehicleDetailPossibleStates.saved),
    ],
  );

  stateNotifierTest<VehicleDetailNotifier, VehicleDetailState>(
    'Should update vehicle and present proper states when there is failure',
    build: () {
      notifier = VehicleDetailNotifier(interactor);
      return notifier;
    },
    setUp: () {
      when(interactor.updateVehicle(vehicleID: "id", name: "new name"))
          .thenAnswer((realInvocation) async => false);
    },
    actions: (notifier) async {
      await notifier.setInitialState();
      await notifier.update(vehicleID: "id", name: "new name");
    },
    expect: () => [
      initialState.copyWith(state: VehicleDetailPossibleStates.saving),
      initialState.copyWith(state: VehicleDetailPossibleStates.failure),
    ],
  );
}

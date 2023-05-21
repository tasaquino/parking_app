import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/features/vehicles/domain/vehicles_interactor.dart';
import 'package:parking_app/features/vehicles/presentation/providers/list/vehicle_list_notifier.dart';
import 'package:parking_app/features/vehicles/presentation/providers/list/vehicle_list_states.dart';
import 'package:test/test.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

import '../detail/vehicle_detail_notifier_test.mocks.dart';

//flutter pub run build_runner build - run it to generate mock files

@GenerateMocks([VehiclesInteractor])
void main() {
  late VehiclesInteractor interactor;
  late VehicleListNotifier notifier;
  const initialState =
      VehicleListState(currentState: VehiclePossibleStates.initial);
  final vehicles = [
    Vehicle(
        id: "id1", selected: true, registrationNumber: "abcd", name: "mycar"),
    Vehicle(
        id: "id2", selected: false, registrationNumber: "efgh", name: "mycar2")
  ];

  setUpAll(() {
    interactor = MockVehiclesInteractor();
  });
  stateNotifierTest<VehicleListNotifier, VehicleListState>(
    'Should present empty list with proper loading states',
    build: () {
      notifier = VehicleListNotifier(interactor);
      return notifier;
    },
    setUp: () {
      when(interactor.fetchVehiclesForUser())
          .thenAnswer((realInvocation) async => List.empty());
    },
    actions: (notifier) async {
      await notifier.fetchVehicles();
    },
    expect: () => [
      initialState.copyWith(currentState: VehiclePossibleStates.loading),
      initialState.copyWith(
          currentState: VehiclePossibleStates.loaded, vehicles: List.empty()),
    ],
  );

  stateNotifierTest<VehicleListNotifier, VehicleListState>(
    'Should present proper list with proper loading states',
    build: () {
      notifier = VehicleListNotifier(interactor);

      return notifier;
    },
    setUp: () {
      when(interactor.fetchVehiclesForUser())
          .thenAnswer((realInvocation) async => vehicles);
    },
    actions: (notifier) async {
      await notifier.fetchVehicles();
    },
    expect: () => [
      initialState.copyWith(currentState: VehiclePossibleStates.loading),
      initialState.copyWith(
          currentState: VehiclePossibleStates.loaded, vehicles: vehicles)
    ],
  );

  stateNotifierTest<VehicleListNotifier, VehicleListState>(
    'Should present proper states when selecting a vehicle',
    build: () {
      notifier = VehicleListNotifier(interactor);

      return notifier;
    },
    setUp: () {
      when(interactor.selectVehicle("id2", true))
          .thenAnswer((realInvocation) async => true);
      when(interactor.fetchVehiclesForUser())
          .thenAnswer((realInvocation) async => vehicles);
    },
    actions: (notifier) async {
      await notifier.setSelected(vehicles[1]);
    },
    expect: () => [
      initialState.copyWith(currentState: VehiclePossibleStates.loading),
      initialState.copyWith(
          currentState: VehiclePossibleStates.loaded, vehicles: vehicles)
    ],
  );

  stateNotifierTest<VehicleListNotifier, VehicleListState>(
    'Should present proper states when deleting a vehicle',
    build: () {
      notifier = VehicleListNotifier(interactor);

      return notifier;
    },
    setUp: () {
      when(interactor.deleteVehicle("id2"))
          .thenAnswer((realInvocation) async => false);
      when(interactor.fetchVehiclesForUser())
          .thenAnswer((realInvocation) async => vehicles);
    },
    actions: (notifier) async {
      await notifier.delete(vehicles[1]);
    },
    expect: () => [
      initialState.copyWith(currentState: VehiclePossibleStates.loading),
      initialState.copyWith(
          currentState: VehiclePossibleStates.loaded, vehicles: vehicles)
    ],
  );
}

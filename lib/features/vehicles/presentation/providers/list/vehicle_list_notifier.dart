import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/features/vehicles/domain/vehicles_interactor.dart';
import 'package:parking_app/features/vehicles/presentation/providers/list/vehicle_list_states.dart';

class VehicleListNotifier extends StateNotifier<VehicleListState> {
  final VehiclesInteractor _interactor;
  VehicleListNotifier(this._interactor)
      : super(const VehicleListState(
            currentState: VehiclePossibleStates.initial));

  Future<void> fetchVehicles() async {
    state = state.copyWith(currentState: VehiclePossibleStates.loading);
    final vehicles = await _interactor.fetchVehiclesForUser();
    state = state.copyWith(
        currentState: VehiclePossibleStates.loaded,
        vehicles: vehicles,
        userID: state.userID);
  }

  Future<void> setSelected(Vehicle vehicle) async {
    await _interactor.selectVehicle(vehicle.id, !vehicle.selected);
    return fetchVehicles();
  }

  Future<void> delete(Vehicle vehicle) async {
    await _interactor.deleteVehicle(vehicle.id);
    return fetchVehicles();
  }
}

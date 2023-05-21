import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/features/vehicles/domain/vehicles_interactor.dart';
import 'package:parking_app/features/vehicles/presentation/providers/detail/vehicle_detail_states.dart';

class VehicleDetailNotifier extends StateNotifier<VehicleDetailState> {
  final VehiclesInteractor _interactor;

  VehicleDetailNotifier(this._interactor)
      : super(const VehicleDetailState(
            state: VehicleDetailPossibleStates.initial));

  Future<void> setInitialState() async {
    state =
        const VehicleDetailState(state: VehicleDetailPossibleStates.initial);
  }

  Future<void> save(Vehicle vehicle) async {
    state = state.copyWith(state: VehicleDetailPossibleStates.saving);
    final result = await _interactor.saveVehicle(vehicle);

    state = result
        ? state.copyWith(state: VehicleDetailPossibleStates.saved)
        : state.copyWith(state: VehicleDetailPossibleStates.failure);
  }

  Future<bool> update(
      {required String vehicleID,
      String? name,
      String? registerNumber,
      bool? selected}) async {
    state = state.copyWith(state: VehicleDetailPossibleStates.saving);

    final result = await _interactor.updateVehicle(
        vehicleID: vehicleID,
        name: name,
        registerNumber: registerNumber,
        selected: selected);

    state = result
        ? state.copyWith(state: VehicleDetailPossibleStates.saved)
        : state.copyWith(state: VehicleDetailPossibleStates.failure);

    return result;
  }
}

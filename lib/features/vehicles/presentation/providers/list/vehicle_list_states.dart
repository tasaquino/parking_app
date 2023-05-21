import 'package:equatable/equatable.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';

enum VehiclePossibleStates {
  initial,
  loading,
  loaded,
  failure,
}

class VehicleListState extends Equatable {
  final List<Vehicle> vehicles;
  final String userID;
  final VehiclePossibleStates currentState;
  final String error;

  const VehicleListState({
    this.vehicles = const [],
    this.userID = "",
    this.currentState = VehiclePossibleStates.initial,
    this.error = "",
  });

  VehicleListState copyWith({
    String? userID,
    List<Vehicle>? vehicles,
    VehiclePossibleStates? currentState,
    String? error,
  }) {
    return VehicleListState(
        vehicles: vehicles ?? this.vehicles,
        userID: userID ?? this.userID,
        currentState: currentState ?? this.currentState,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [vehicles, currentState, error];
}

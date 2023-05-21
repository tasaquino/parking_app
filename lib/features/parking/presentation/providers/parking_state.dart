import 'package:equatable/equatable.dart';
import 'package:parking_app/features/parking/data/models/parking.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';

enum ParkingPossibleStates {
  initial,
  starting,
  started,
  stopping,
  stopped,
}

class ParkingState extends Equatable {
  final Vehicle? selectedVehicle;
  final Parking? currentParking;
  final ParkingPossibleStates state;

  const ParkingState({
    this.selectedVehicle,
    this.currentParking,
    this.state = ParkingPossibleStates.initial,
  });

  ParkingState copyWith({
    Vehicle? vehicle,
    Parking? parking,
    ParkingPossibleStates? state,
  }) {
    return ParkingState(
      selectedVehicle: vehicle ?? selectedVehicle,
      currentParking: parking ?? currentParking,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [selectedVehicle, state, currentParking];
}

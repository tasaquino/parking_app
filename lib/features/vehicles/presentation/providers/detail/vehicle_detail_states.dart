import 'package:equatable/equatable.dart';

enum VehicleDetailPossibleStates {
  initial,
  saving,
  saved,
  failure,
}

class VehicleDetailState extends Equatable {
  final String vehicleID;
  final VehicleDetailPossibleStates state;

  const VehicleDetailState(
      {this.vehicleID = "", this.state = VehicleDetailPossibleStates.initial});

  VehicleDetailState copyWith({
    String? vehicleID,
    VehicleDetailPossibleStates? state,
  }) {
    return VehicleDetailState(
        vehicleID: vehicleID ?? this.vehicleID, state: state ?? this.state);
  }

  @override
  List<Object?> get props => [vehicleID, state];
}

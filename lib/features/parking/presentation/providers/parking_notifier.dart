import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/parking/data/models/parking.dart';
import 'package:parking_app/features/parking/domain/parking_interactor.dart';
import 'package:parking_app/features/parking/presentation/providers/parking_state.dart';
import 'package:parking_app/features/places/data/models/parking_place.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:uuid/uuid.dart';

class ParkingNotifier extends StateNotifier<ParkingState> {
  final ParkingInteractor _interactor;
  ParkingNotifier(this._interactor)
      : super(const ParkingState(state: ParkingPossibleStates.initial));

  Future<void> setInitialState(Parking? parking) async {
    if (parking != null) {
      state = ParkingState(
          currentParking: parking, state: ParkingPossibleStates.initial);
    }
    state = const ParkingState(state: ParkingPossibleStates.initial);
  }

  Future<void> startParking(
      Vehicle vehicle, double price, ParkingPlace place) async {
    state = state.copyWith(
      state: ParkingPossibleStates.starting,
    );
    final parking = Parking(
        parkingID: const Uuid().v4(),
        placeID: place.id,
        placeName: place.name ?? "",
        placeAddress: place.address ?? "",
        vehicleID: vehicle.id,
        start: DateTime.now(),
        vehicleRegistration: vehicle.registrationNumber);
    await _interactor.startParking(
      parking,
    );
    state =
        state.copyWith(state: ParkingPossibleStates.started, parking: parking);
  }

  Future<void> stopParking(Vehicle vehicle, double price, ParkingPlace place,
      String parkingID) async {
    final parking = state.currentParking;
    state =
        state.copyWith(state: ParkingPossibleStates.stopping, parking: parking);

    if (parking != null) {
      await _interactor.stopParking(parking!);
      state = state.copyWith(
          state: ParkingPossibleStates.stopped, parking: parking);
    }
  }

  Future<void> setVehicleSelected(Vehicle vehicle) async {
    state = state.copyWith(vehicle: vehicle);
  }
}

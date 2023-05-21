import 'package:parking_app/features/parking/data/models/parking.dart';
import 'package:parking_app/features/parking/data/parking_repository.dart';
import 'package:parking_app/features/parking/domain/parking_interactor.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/features/vehicles/data/vehicles_repository.dart';

class ParkingInteractorImpl implements ParkingInteractor {
  final ParkingRepository _parkingRepository;
  final VehiclesRepository _vehiclesRepository;
  const ParkingInteractorImpl(
      this._parkingRepository, this._vehiclesRepository);

  @override
  Future<bool> startParking(Parking parking, {DateTime? time}) {
    return _parkingRepository.save(parking, time: time ?? DateTime.now());
  }

  @override
  Future<bool> stopParking(Parking parking, {DateTime? time}) {
    return _parkingRepository.update(parking, time: time ?? DateTime.now());
  }

  @override
  Future<Parking> getOngoingParking() {
    return _parkingRepository.getOngoingParking();
  }
}

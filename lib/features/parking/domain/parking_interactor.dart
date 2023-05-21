import 'package:parking_app/features/parking/data/models/parking.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';

abstract class ParkingInteractor {
  Future<bool> startParking(Parking parking, {DateTime? time});
  Future<bool> stopParking(Parking parking, {DateTime? time});
  Future<Parking> getOngoingParking();
}

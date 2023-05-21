import 'package:parking_app/features/parking/data/models/parking.dart';

abstract class ParkingRepository {
  Future<bool> save(Parking parking, {DateTime? time});
  Future<bool> update(Parking parking, {DateTime? time});
  Future<Parking> getOngoingParking();
}

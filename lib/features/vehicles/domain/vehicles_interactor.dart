import 'package:parking_app/features/vehicles/data/models/vehicle.dart';

abstract class VehiclesInteractor {
  Future<bool> saveVehicle(Vehicle vehicle);
  Future<bool> deleteVehicle(String vehicleID);
  Future<bool> updateVehicle(
      {required String vehicleID,
      String? name,
      String? registerNumber,
      bool? selected});
  Future<List<Vehicle>> fetchVehiclesForUser();
  Future<bool> selectVehicle(String vehicleID, bool select);
}

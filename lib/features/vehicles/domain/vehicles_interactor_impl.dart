import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/features/vehicles/data/vehicles_repository.dart';
import 'package:parking_app/features/vehicles/domain/vehicles_interactor.dart';

class VehiclesInteractorImpl implements VehiclesInteractor {
  VehiclesInteractorImpl(this._repository);
  final VehiclesRepository _repository;

  @override
  Future<bool> deleteVehicle(String vehicleID) {
    return _repository.deleteVehicle(vehicleID);
  }

  @override
  Future<List<Vehicle>> fetchVehiclesForUser() async {
    final vehicles = await _repository.fetchVehiclesForUser();
    return [
      ...vehicles.where((v) => v.selected == true),
      ...vehicles.where((v) => v.selected == false)
    ];
  }

  @override
  Future<bool> saveVehicle(Vehicle vehicle) async {
    bool result = await _repository.saveVehicle(vehicle);

    if (result && vehicle.selected) {
      await _setOtherVehiclesUnselected(vehicle.id);
    }

    return result;
  }

  @override
  Future<bool> selectVehicle(String vehicleID, bool select) async {
    bool result =
        await _repository.updateVehicle(vehicleID: vehicleID, selected: select);

    if (result && select) {
      await _setOtherVehiclesUnselected(vehicleID);
    }

    return result;
  }

  @override
  Future<bool> updateVehicle(
      {required String vehicleID,
      String? name,
      String? registerNumber,
      bool? selected}) async {
    bool result = await _repository.updateVehicle(
        vehicleID: vehicleID,
        name: name,
        registerNumber: registerNumber,
        selected: selected);

    if (result && selected == true) {
      await _setOtherVehiclesUnselected(vehicleID);
    }

    return result;
  }

  Future<bool> _setOtherVehiclesUnselected(String vehicleID) async {
    final vehicles = await fetchVehiclesForUser();

    for (var vehicle in vehicles) {
      if (vehicle.id != vehicleID && vehicle.selected) {
        await _repository.updateVehicle(vehicleID: vehicle.id, selected: false);
      }
    }

    return true;
  }
}

import 'package:parking_app/features/user/data/user_repository.dart';
import 'package:parking_app/features/vehicles/data/vehicles_repository.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/utils/app_configuration.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VehiclesRepositoryImpl implements VehiclesRepository {
  VehiclesRepositoryImpl(this._httpClient, this._userRepository);

  final http.Client _httpClient;
  final UserRepository _userRepository;

  Future<Uri> _buildVehicleUriFor({String? vehicleID}) async {
    final token = await _userRepository.getAuthToken();
    if (vehicleID != null) {
      return Uri.https(
          AppConfiguration.projectUrl,
          'users/${_userRepository.getUserID()}/vehicles/$vehicleID.json',
          {'auth': token});
    }

    return Uri.https(AppConfiguration.projectUrl,
        'users/${_userRepository.getUserID()}/vehicles.json', {'auth': token});
  }

  @override
  Future<bool> saveVehicle(Vehicle vehicle) async {
    final url = await _buildVehicleUriFor(vehicleID: vehicle.id);
    final response = await _httpClient.put(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "id": vehicle.id,
          "name": vehicle.name,
          "registrationNumber": vehicle.registrationNumber,
          "selected": vehicle.selected,
        }));
    return response.statusCode == 200;
  }

  @override
  Future<bool> deleteVehicle(String vehicleID) async {
    final url = await _buildVehicleUriFor(vehicleID: vehicleID);
    final response = await _httpClient.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  @override
  Future<bool> updateVehicle(
      {required String vehicleID,
      String? name,
      String? registerNumber,
      bool? selected}) async {
    final url = await _buildVehicleUriFor(vehicleID: vehicleID);
    Map<String, dynamic> map = {};

    if (name != null) {
      map.putIfAbsent('name', () => name);
    }

    if (registerNumber != null) {
      map.putIfAbsent('registrationNumber', () => registerNumber);
    }

    if (selected != null) {
      map.putIfAbsent('selected', () => selected);
    }

    final response = await _httpClient.patch(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(map));
    return response.statusCode == 200;
  }

  @override
  Future<List<Vehicle>> fetchVehiclesForUser() async {
    final url = await _buildVehicleUriFor();
    final response = await _httpClient.get(url, headers: {
      'Content-Type': 'application/json',
    });
    List<Vehicle> vehicles = [];
    if (response.statusCode == 200 && response.body != 'null') {
      final Map<String, dynamic> data = json.decode(response.body);
      for (final entry in data.entries) {
        vehicles.add(Vehicle(
            id: entry.value['id'],
            selected: entry.value['selected'],
            registrationNumber: entry.value['registrationNumber'],
            name: entry.value['name']));
      }
    }

    return vehicles;
  }
}

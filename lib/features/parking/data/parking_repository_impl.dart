import 'dart:convert';

import 'package:parking_app/features/parking/data/models/parking.dart';
import 'package:parking_app/features/parking/data/parking_repository.dart';
import 'package:http/http.dart' as http;
import 'package:parking_app/utils/app_configuration.dart';
import 'package:parking_app/features/user/data/user_repository.dart';

class ParkingRepositoryImpl implements ParkingRepository {
  ParkingRepositoryImpl(this._httpClient, this._userRepository);

  final http.Client _httpClient;
  final UserRepository _userRepository;

  Future<Uri> _buildUrl({String? parkingID, String? query}) async {
    final token = await _userRepository.getAuthToken();
    if (parkingID != null) {
      return Uri.https(
          AppConfiguration.projectUrl,
          'users/${_userRepository.getUserID()}/parkings/$parkingID.json${query ?? ""}',
          {'auth': token});
    }

    return Uri.https(
        AppConfiguration.projectUrl,
        'users/${_userRepository.getUserID()}/parkings.json?${query ?? ""}',
        {'auth': token});
  }

  @override
  Future<Parking> getOngoingParking() async {
    final url = await _buildUrl(query: '?orderBy=\"end\"&startAt="0"');
    final response = await _httpClient.get(url, headers: {
      'Content-Type': 'application/json',
    });
    List<Parking> parkings = [];

    if (response.statusCode == 200 && response.body != 'null') {
      final Map<String, dynamic> data = json.decode(response.body);
      for (final entry in data.entries) {
        parkings.add(Parking(
            placeID: entry.value['id'],
            placeName: entry.value['placeName'],
            placeAddress: entry.value['placeAddress'],
            vehicleID: entry.value['vehicleID'],
            vehicleRegistration: entry.value['vehicleRegistration']));
      }
    }

    return parkings.first;
  }

  @override
  Future<bool> save(Parking parking, {DateTime? time}) async {
    final url = await _buildUrl(parkingID: parking.parkingID);
    final response = await _httpClient.put(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "placeID": parking.placeID,
          "placeName": parking.placeName,
          "placeAddress": parking.placeAddress,
          "vehicleID": parking.vehicleID,
          "vehicleRegistration": parking.vehicleRegistration,
          "start": time?.millisecondsSinceEpoch ??
              parking.start?.millisecondsSinceEpoch ??
              0,
          "end": parking.end?.millisecondsSinceEpoch ?? 0,
        }));
    return response.statusCode == 200;
  }

  @override
  Future<bool> update(Parking parking, {DateTime? time}) async {
    final url = await _buildUrl(parkingID: parking.parkingID);
    final response = await _httpClient.patch(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "placeID": parking.placeID,
          "placeName": parking.placeName,
          "placeAddress": parking.placeAddress,
          "vehicleID": parking.vehicleID,
          "vehicleRegistration": parking.vehicleRegistration,
          "start": parking.start?.millisecondsSinceEpoch ?? 0,
          "end": time?.millisecondsSinceEpoch ??
              parking.end?.millisecondsSinceEpoch ??
              0,
        }));
    return response.statusCode == 200;
  }
}

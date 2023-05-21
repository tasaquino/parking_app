class ParkingPlace {
  const ParkingPlace(
      {required this.id,
      this.latitude,
      this.longitude,
      this.name,
      this.address});
  final String id;
  final double? latitude;
  final double? longitude;
  final String? name;
  final String? address;
}

class Parking {
  const Parking({
    this.parkingID = "",
    required this.placeID,
    required this.placeName,
    required this.placeAddress,
    required this.vehicleID,
    required this.vehicleRegistration,
    this.price,
    this.start,
    this.end,
  });

  final String parkingID;
  final String placeID;
  final String placeName;
  final String placeAddress;
  final String vehicleID;
  final String vehicleRegistration;
  final double? price;
  final DateTime? start;
  final DateTime? end;
}

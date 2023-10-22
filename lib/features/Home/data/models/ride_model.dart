class RideModel {
  String? locationAddress;
  String? destinationAddress;
  String? time;
  String? clientName;
  String? clientImageUrl;
  String? ridePrice;
  String? driverUID;
  String? paymentMethod;
  String? userUId;
  double? lat;
  double? lng;
  RideModel(
      {this.locationAddress,
      this.destinationAddress,
      this.time,
      this.clientName,
      this.clientImageUrl,
      this.ridePrice,
      this.driverUID,
      this.paymentMethod,
      this.userUId,
      this.lat,
      this.lng});
  factory RideModel.fromFireStore(Map<String, dynamic> ride) {
    return RideModel(
        locationAddress: ride['locationAddress'],
        destinationAddress: ride['destinationAddress'],
        clientImageUrl: ride['clienImageUrl'],
        clientName: ride['clientName'],
        driverUID: ride['driverUID'],
        paymentMethod: ride['paymentMethod'],
        ridePrice: ride['ridePrice'],
        time: ride['time'],
        userUId: ride['userUid'],
        lat: ride['lat'],
        lng: ride['lng']);
  }
}

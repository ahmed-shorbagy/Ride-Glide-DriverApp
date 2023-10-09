import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Location extends Equatable {
  double? lat;
  double? lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: (json['lat'] as num?)?.toDouble(),
        lng: (json['lng'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };

  @override
  List<Object?> get props => [lat, lng];
}

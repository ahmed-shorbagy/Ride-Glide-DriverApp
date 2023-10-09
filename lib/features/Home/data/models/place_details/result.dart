import 'package:equatable/equatable.dart';

import 'geometry.dart';

class Result extends Equatable {
	final Geometry? geometry;

	const Result({this.geometry});

	factory Result.fromJson(Map<String, dynamic> json) => Result(
				geometry: json['geometry'] == null
						? null
						: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toJson() => {
				'geometry': geometry?.toJson(),
			};

	@override
	List<Object?> get props => [geometry];
}

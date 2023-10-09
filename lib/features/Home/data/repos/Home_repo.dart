import 'package:dartz/dartz.dart';
import 'package:ride_glide_driver_app/core/errors/Faluire_model.dart';
import 'package:ride_glide_driver_app/features/Home/data/models/place_details/place_details.dart';
import 'package:ride_glide_driver_app/features/Home/data/models/place_model/place_model.dart';

abstract class HomeRepo {
  Future<Either<Faluire, List<PlaceModel>>> getAutoComplete(
      {required String searchInput});
  Future<Either<Faluire, PlaceDetails>> getPlaceDeatils(
      {required String placeID});
  Future<Either<Faluire, String?>> getPlaceId(
      {required double latitude, required double longitude});
  Future<Either<Faluire, String?>> getPlaceName(
      {required double latitude, required double longitude});
}

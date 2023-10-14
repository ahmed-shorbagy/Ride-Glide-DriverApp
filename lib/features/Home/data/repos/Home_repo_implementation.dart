import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ride_glide_driver_app/core/errors/Faluire_model.dart';
import 'package:ride_glide_driver_app/core/utils/api_service.dart';
import 'package:ride_glide_driver_app/features/Home/data/models/place_details/place_details.dart';
import 'package:ride_glide_driver_app/features/Home/data/models/place_model/place_model.dart';
import 'package:ride_glide_driver_app/features/Home/data/models/ride_model.dart';
import 'package:ride_glide_driver_app/features/Home/data/repos/Home_repo.dart';
import 'package:ride_glide_driver_app/features/auth/data/AuthRepo/authRepoImpl.dart';

class HomeRepoImpl implements HomeRepo {
  final ApiService apiService;
  final String key = 'AIzaSyCwAe3qJC0pDaLbovyNykTSLRaY5r7N--g';
  final String types = 'geocode';

  HomeRepoImpl({required this.apiService});
  @override
  @override
  Future<Either<Faluire, List<PlaceModel>>> getAutoComplete(
      {required String searchInput}) async {
    try {
      var data = await apiService.get(
          url:
              'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchInput&types=$types&components=country:EG&key=$key');

      List<PlaceModel> placesList = [];
      for (var item in data['predictions']) {
        placesList.add(PlaceModel.fromJson(item));
      }
      return right(placesList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFaliure.fromDioErr(e));
      }
      return left(ServerFaliure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Faluire, PlaceDetails>> getPlaceDeatils(
      {required String placeID}) async {
    try {
      var data = await apiService.get(
          url:
              'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&fields=geometry&key=$key');

      return right(PlaceDetails.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFaliure.fromDioErr(e));
      }
      return left(ServerFaliure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Faluire, String?>> getPlaceId(
      {required double latitude, required double longitude}) async {
    try {
      var data = await apiService.get(
          url:
              'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$key');
      final placeId = data['results'][0]['place_id'];

      return right(placeId);
    } catch (e) {
      return left(ServerFaliure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Faluire, String?>> getPlaceName(
      {required double latitude, required double longitude}) async {
    try {
      var data = await apiService.get(
          url:
              'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$key');
      final placeId = data['results'][0]["formatted_address"];

      return right(truncateStringAfterWords(placeId, 10));
    } catch (e) {
      return left(ServerFaliure(errMessage: e.toString()));
    }
  }

  String truncateStringAfterWords(String input, int wordLimit) {
    // Split the input string into words using space as the delimiter
    List<String> words = input.split(' ');

    // If the number of words is less than or equal to the wordLimit, return the original string
    if (words.length <= wordLimit) {
      return input;
    }

    // Take only the first wordLimit words and join them back together with spaces
    List<String> truncatedWords = words.take(wordLimit).toList();
    return truncatedWords.join(' ');
  }

  static List<RideModel> rideRequests = [];
  static StreamController<List<RideModel>> rideRequestsStreamController =
      StreamController<List<RideModel>>.broadcast();

  static Either<Faluire, void> listenForRideRequests(String driverId) {
    try {
      final CollectionReference ridesCollection =
          FirebaseFirestore.instance.collection('Rides');

      final Query query =
          ridesCollection.where('driverUID', isEqualTo: auth.currentUser?.uid);

      final Stream<QuerySnapshot> rideStream = query.snapshots();

      rideStream.listen((QuerySnapshot snapshot) async {
        List<RideModel> newRideRequests = [];
        for (QueryDocumentSnapshot rideDoc in snapshot.docs) {
          // Handle the new ride request document here
          final newRide =
              RideModel.fromFireStore(rideDoc.data() as Map<String, dynamic>);
          newRideRequests.add(newRide); // Add the new ride to the list
        }

        // Add the new ride requests to the stream
        rideRequestsStreamController.add(newRideRequests);
        await AudioPlayer()
            .play(AssetSource('notifications-sound-127856.mp3'), volume: 4);
      });
      return right(rideStream);
    } catch (e) {
      return left(ServerFaliure(errMessage: e.toString()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:ride_glide_driver_app/features/Home/data/models/place_details/place_details.dart';
import 'package:ride_glide_driver_app/features/Home/data/repos/Home_repo.dart';

part 'place_details_state.dart';

class PlaceDetailsCubit extends Cubit<PlaceDetailsState> {
  PlaceDetailsCubit(this.homeRepo) : super(PlaceDetailsInitial());
  final HomeRepo homeRepo;
  static PlaceDetails? fromPLaceDetails = const PlaceDetails();
  static PlaceDetails? toPLaceDetails = const PlaceDetails();
  static bool isFrom = true;
  static bool isTO = false;
  Future<void> getPlaceDetails({required String placeID}) async {
    emit(PlaceDetailsLoading());
    var responce = await homeRepo.getPlaceDeatils(placeID: placeID);
    responce.fold((faluire) {
      emit(PlaceDetailsFaluire(errMessage: faluire.errMessage));
    }, (place) {
      emit(PlaceDetailsSuccess(placeDetails: place));
    });
  }

  Future<String?> getPlaceId(
      {required double latitude, required double longitude}) async {
    String placeId = '';
    var responce =
        await homeRepo.getPlaceId(latitude: latitude, longitude: longitude);
    responce.fold((faluire) {
      emit(PlaceDetailsFaluire(errMessage: faluire.errMessage));
    }, (placeID) {
      placeId = placeID!;
    });
    return placeId;
  }

  Future<String?> getPlaceName(
      {required double latitude, required double longitude}) async {
    String placeName = '';
    var responce =
        await homeRepo.getPlaceName(latitude: latitude, longitude: longitude);
    responce.fold((faluire) {
      emit(PlaceDetailsFaluire(errMessage: faluire.errMessage));
    }, (placeID) {
      placeName = placeID!;
    });
    return placeName;
  }

  void textFieldPressed() {
    emit(PlaceDetailsTextFieldPressed());
  }

  void renewSelections() {
    emit(PlaceDetailsInitial());
  }

  void selectionComplete() {
    emit(PlaceDetailsSelectionComplete());
  }
}

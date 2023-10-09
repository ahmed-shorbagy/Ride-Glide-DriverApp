part of 'place_details_cubit.dart';

@immutable
sealed class PlaceDetailsState {}

final class PlaceDetailsInitial extends PlaceDetailsState {}

final class PlaceDetailsLoading extends PlaceDetailsState {}

final class PlaceDetailsSuccess extends PlaceDetailsState {
  final PlaceDetails placeDetails;

  PlaceDetailsSuccess({required this.placeDetails});
}

final class PlaceDetailsFaluire extends PlaceDetailsState {
  final String errMessage;

  PlaceDetailsFaluire({required this.errMessage});
}

final class PlaceDetailsTextFieldPressed extends PlaceDetailsState {}

final class PlaceDetailsSelectionComplete extends PlaceDetailsState {}

part of 'places_auto_complete_cubit.dart';

@immutable
sealed class PlacesAutoCompleteState {}

final class PlacesAutoCompleteInitial extends PlacesAutoCompleteState {}

final class PlacesAutoCompleteLoading extends PlacesAutoCompleteState {}

final class PlacesAutoCompleteSuccess extends PlacesAutoCompleteState {
  final List<PlaceModel> autoCompleteList;

  PlacesAutoCompleteSuccess({required this.autoCompleteList});
}

final class PlacesAutoCompleteFaluire extends PlacesAutoCompleteState {
  final String errMessage;

  PlacesAutoCompleteFaluire({required this.errMessage});
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ride_glide_driver_app/features/Home/data/models/place_model/place_model.dart';
import 'package:ride_glide_driver_app/features/Home/data/repos/Home_repo.dart';

part 'places_auto_complete_state.dart';

class PlacesAutoCompleteCubit extends Cubit<PlacesAutoCompleteState> {
  PlacesAutoCompleteCubit(this.homeRepo) : super(PlacesAutoCompleteInitial());
  final HomeRepo homeRepo;

  Future<void> searchedPlaces({required String searchedInput}) async {
    emit(PlacesAutoCompleteLoading());
    var responce = await homeRepo.getAutoComplete(searchInput: searchedInput);
    responce.fold((faluire) {
      emit(PlacesAutoCompleteFaluire(errMessage: faluire.errMessage));
    }, (placesList) {
      emit(PlacesAutoCompleteSuccess(autoCompleteList: placesList));
    });
  }
}

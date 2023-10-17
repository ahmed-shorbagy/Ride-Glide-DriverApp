import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ride_glide_driver_app/features/auth/data/AuthRepo/authRepoImpl.dart';
import 'package:ride_glide_driver_app/features/auth/data/models/driver_Model.dart';

part 'get_user_data_state.dart';

class GetUserDataCubit extends Cubit<GetUserDataState> {
  GetUserDataCubit(this.authRepo) : super(GetUserDataInitial());

  final AuthRepo authRepo;
  Future<void> getUserData({required String uId}) async {
    emit(GetUserDataLoading());

    var responce = await authRepo.getUserData(uid: uId);
    responce.fold((faluire) {
      emit(GetUserDataFaluire(errMessage: faluire.errMessage));
    }, (driver) {
      emit(GetUserDataSuccess(driver: driver));
    });
  }
}

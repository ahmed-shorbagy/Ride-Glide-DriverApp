import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ride_glide_driver_app/features/auth/data/AuthRepo/authRepoImpl.dart';

part 'delete_password_state.dart';

class DeletePasswordCubit extends Cubit<DeletePasswordState> {
  DeletePasswordCubit() : super(DeletePasswordInitial());

  Future<void> deleteAccount() async {
    try {
      emit(DeletePasswordLoading());
      await auth.currentUser?.delete();
      emit(DeletePasswordSuccess());
    } catch (e) {
      emit(DeletePasswordFaluire(errMessage: e.toString()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ride_glide_driver_app/features/auth/data/AuthRepo/authRepoImpl.dart';

part 'update_image_state.dart';

class UpdateImageCubit extends Cubit<UpdateImageState> {
  UpdateImageCubit(this.authRepo) : super(UpdateImageInitial());
  final AuthRepo authRepo;
  Future<void> uploadDriverImageToFirebase({required String imagePath}) async {
    emit(UpdateImageLoading());
    var responce = await authRepo.uploadDriverPhoto(imagePath);
    responce.fold((faluire) {
      emit(UpdateImageFaluire(errMessage: faluire.errMessage));
    }, (url) {
      emit(UpdateImageSuccess(imageUrl: url));
    });
  }
}

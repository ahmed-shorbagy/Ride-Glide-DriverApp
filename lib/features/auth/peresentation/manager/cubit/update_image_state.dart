part of 'update_image_cubit.dart';

@immutable
sealed class UpdateImageState {}

final class UpdateImageInitial extends UpdateImageState {}

final class UpdateImageLoading extends UpdateImageState {}

final class UpdateImageSuccess extends UpdateImageState {
  final String imageUrl;

  UpdateImageSuccess({required this.imageUrl});
}

final class UpdateImageFaluire extends UpdateImageState {
  final String errMessage;

  UpdateImageFaluire({required this.errMessage});
}

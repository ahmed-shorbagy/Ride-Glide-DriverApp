import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:ride_glide_driver_app/features/auth/data/AuthRepo/authRepoImpl.dart';

part 'email_paswword_state.dart';

class EmailPaswwordCubit extends Cubit<EmailPaswwordState> {
  final AuthRepo authRepo;
  EmailPaswwordCubit(this.authRepo) : super(EmailPaswwordInitial());
  Future<void> signupUser(
      {required String email, required String password}) async {
    emit(EmailPaswwordLoadin());

    final userCredential = await authRepo.signUpWIthEmailAndPassword(
        email: email, password: password);
    userCredential.fold((faluire) {
      emit(EmailPaswwordFaluire(errMessage: faluire.errMessage));
    }, (success) {
      emit(EmailPaswwordSuccess());
    });
  }

  Future<void> signInUser(
      {required String email, required String password}) async {
    emit(EmailPaswwordLoadin());

    final userCredential = await authRepo.signInWIthEmailAndPassword(
        email: email, password: password);
    userCredential.fold((faluire) {
      emit(EmailPaswwordFaluire(errMessage: faluire.errMessage));
    }, (success) {
      emit(EmailPaswwordSuccess());
    });
  }

  Future<void> addDriverToFireStore({
    required String name,
    required String email,
    required String carType,
    required String carColor,
    required String address,
    required String gender,
    required String imgaeUrl,
  }) async {
    final driver = await authRepo.addNewDriverToFireStore(
        name: name,
        email: email,
        carType: carType,
        carColor: carColor,
        address: address,
        gender: gender,
        imageUrl: imgaeUrl);
    driver.fold((faluire) {
      emit(EmailPaswwordFaluire(errMessage: faluire.errMessage));
      debugPrint('this is th eeroeeeaaASSA===== ${faluire.errMessage}');
    }, (success) {});
  }

  Future<void> updateDriverStatus({required status}) async {
    final driver = await AuthRepo.updateDriverStatus(status: status);
    driver.fold((faluire) {
      emit(EmailPaswwordFaluire(errMessage: faluire.errMessage));
    }, (success) {});
  }
}

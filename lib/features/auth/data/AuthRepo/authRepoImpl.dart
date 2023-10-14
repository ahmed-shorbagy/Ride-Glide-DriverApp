import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:ride_glide_driver_app/core/errors/Faluire_model.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class AuthRepo {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static final firestore = FirebaseFirestore.instance;
  String verificationId = '';
  get context => null;

  Future<Either<Faluire, String>> uploadDriverPhoto(String imagePath) async {
    try {
      final storage = FirebaseStorage.instance;
      final storageRef =
          storage.ref().child('driver_photos/${auth.currentUser?.uid}.jpg');
      final uploadTask = storageRef.putFile(File(imagePath));

      // Wait for the upload to complete and get the download URL
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadURL = await snapshot.ref.getDownloadURL();

      return right(downloadURL);
    } catch (e) {
      // Handle upload errors
      debugPrint('Error uploading driver photo: $e');
      return left(FirbaseFaluire.fromFirebaseAuth(e.toString()));
    }
  }

  static Future<Either<Faluire, void>> updateDriverStatus(
      {required status}) async {
    try {
      final driverRef =
          firestore.collection('Drivers').doc(auth.currentUser?.uid);
      await driverRef.update({
        'status': status,
      });
      return right(null);
    } catch (e) {
      return left(FirbaseFaluire.fromFirebaseAuth(e.toString()));
    }
  }

  Future<Either<Faluire, void>> addNewDriverToFireStore({
    required String name,
    required String email,
    required String carType,
    required String carColor,
    required String address,
    required String gender,
    required String imageUrl,
  }) async {
    try {
      final driverRef =
          firestore.collection('Drivers').doc(auth.currentUser?.uid);
      await driverRef.set({
        'name': name,
        'email': email,
        'status': true,
        'carColor': carColor,
        'carType': carType,
        'address': address,
        'gender': gender,
        'imageUrl': imageUrl,
        'uId': auth.currentUser?.uid ?? ''
      });
      return right(null);
    } catch (e) {
      return left(FirbaseFaluire.fromFirebaseAuth(e.toString()));
    }
  }

  Future<Either<Faluire, void>> phoneAuth(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      return left(FirbaseFaluire.fromFirebaseAuth(e.toString()));
    }
    return right(null);
  }

  Future<Either<Faluire, bool>> verifyOtp(String otp) async {
    try {
      var credential = await auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: otp));
      return right(credential.user != null ? true : false);
    } catch (e) {
      return left(FirbaseFaluire.fromFirebaseAuth(e.toString()));
    }
  }

  Future<Either<Faluire, UserCredential?>> signUpWIthEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return right(credential);
    } catch (e) {
      debugPrint(' the exception ISSSSSSS =  ${e.toString()}');

      return left(FirbaseFaluire.fromFirebaseAuth(e.toString()));
    }
  }

  Future<Either<Faluire, UserCredential?>> signInWIthEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return right(credential);
    } catch (e) {
      debugPrint('the exception ISSSSSSS== ${e.toString()}');
      return left(FirbaseFaluire.fromFirebaseAuth(e.toString()));
    }
  }

  Future<bool> verifyEmail({required String email}) async {
    try {
      final signInMethods = await auth.fetchSignInMethodsForEmail(
        email,
      );
      if (signInMethods.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Either<Faluire, void>> updateUserPassword(
      {required String email}) async {
    try {
      final credential = await auth.sendPasswordResetEmail(email: email);
      return right(credential);
    } catch (e) {
      debugPrint('the exception ISSSSSSS== ${e.toString()}');
      return left(FirbaseFaluire.fromFirebaseAuth(e.toString()));
    }
  }

  // Define a timer variable
  static Timer? statusUpdateTimer;

// Function to reset the timer
  static void resetStatusUpdateTimer() {
    statusUpdateTimer?.cancel(); // Cancel the previous timer if it exists
    statusUpdateTimer = Timer(const Duration(minutes: 15), () {
      // Set the driver's status to offline after 15 minutes of inactivity
      updateDriverStatus(status: false);
    });
  }

// Function to track user activity and reset the timer
  static void trackUserActivity() {
    // Call this function whenever the user performs an activity
    resetStatusUpdateTimer();
    updateDriverStatus(status: true);
  }

// Call resetStatusUpdateTimer initially when the user signs in
// This assumes that the user is initially active

// Example usage: Call trackUserActivity whenever the user interacts with the app
// For example, in GestureDetector or InkWell onTap callbacks.
}

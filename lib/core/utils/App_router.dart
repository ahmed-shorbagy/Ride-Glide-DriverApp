import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_glide_driver_app/core/utils/service_locator.dart';
import 'package:ride_glide_driver_app/features/Home/data/repos/Home_repo_implementation.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/manager/Places_auto_complete_cubit/places_auto_complete_cubit.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/manager/places_details_cubit/place_details_cubit.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/Profile_view.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/SelectTransport_View.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/home_view.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/views/widgets/new_ride_route_body.dart';
import 'package:ride_glide_driver_app/features/auth/data/AuthRepo/authRepoImpl.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/update_image_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/OTP_view.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/setProfile_view.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/set_password_view.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/signInView.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/sign_up_view.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/verify_email_view.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/views/welcome_view.dart';
import 'package:ride_glide_driver_app/features/splash&OnBoarding/on_boarding_view.dart';
import 'package:ride_glide_driver_app/features/splash&OnBoarding/peresentation/views/splash_view.dart';

abstract class AppRouter {
  static const String kHomeView = '/HomeView';
  static const String kOnBoardingView = '/OnBoardingView';
  static const String kAuthWelcomeView = '/AuthWelcomeView';
  static const String kSignUpView = '/SignUpView';
  static const String kOTPView = '/OTPView';
  static const String kSetPaswwordView = '/SetPaswwordView';
  static const String kSetProfileView = '/SetProfileView';
  static const String kSignInView = '/SignInView';
  static const String kverifyEmailView = '/verifyEmailView';
  static const String kSelectTransportView = '/SelectTransportView';
  static const String kAvaialbeCarsView = '/AvaialbeCarsView';
  static const String kChooseLocationOnMapView = '/ChooseLocationOnMapView';
  static const String kNewRideRouteView = '/NewRideRouteView';
  static const String kProfileView = '/ProfileView';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashVIew(),
      ),
      GoRoute(
        path: kHomeView,
        pageBuilder: (context, state) {
          return basicTransition(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      PlacesAutoCompleteCubit(getIt.get<HomeRepoImpl>()),
                ),
                BlocProvider(
                  create: (context) =>
                      PlaceDetailsCubit(getIt.get<HomeRepoImpl>()),
                ),
              ],
              child: const HomeView(),
            ),
          );
        },
      ),
      GoRoute(
        path: kOnBoardingView,
        builder: (context, state) => const OnBoardingView(),
      ),
      GoRoute(
        path: kAuthWelcomeView,
        pageBuilder: (context, state) {
          return basicTransition(child: const WelcomeView());
        },
      ),
      GoRoute(
        path: kSignUpView,
        pageBuilder: (context, state) {
          return basicTransition(child: const SignUpView());
        },
      ),
      GoRoute(
        path: kOTPView,
        pageBuilder: (context, state) {
          return basicTransition(child: const OTPView());
        },
      ),
      GoRoute(
        path: kNewRideRouteView,
        pageBuilder: (context, state) {
          return basicTransition(child: const NewRideRouteBody());
        },
      ),
      GoRoute(
        path: kSetPaswwordView,
        pageBuilder: (context, state) {
          return basicTransition(child: const SetPasswordView());
        },
      ),
      GoRoute(
        path: kSetProfileView,
        pageBuilder: (context, state) {
          return basicTransition(
              child: BlocProvider(
            create: (context) => UpdateImageCubit(AuthRepo()),
            child: const SetProfileView(),
          ));
        },
      ),
      GoRoute(
        path: kSignInView,
        pageBuilder: (context, state) {
          return basicTransition(child: const SignInView());
        },
      ),
      GoRoute(
        path: kProfileView,
        pageBuilder: (context, state) {
          return stylishSideTransition(
            child: const UserProfileView(),
          );
        },
      ),
      GoRoute(
        path: kverifyEmailView,
        pageBuilder: (context, state) {
          return basicTransition(child: const VerifyEmailView());
        },
      ),
      GoRoute(
        path: kSelectTransportView,
        pageBuilder: (context, state) {
          return basicTransition(child: const SelectTransportView());
        },
      ),
    ],
  );
}

CustomTransitionPage basicTransition({required child}) {
  return CustomTransitionPage(
    transitionDuration: const Duration(milliseconds: 400),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
  );
}

CustomTransitionPage stylishSideTransition({required child}) {
  return CustomTransitionPage(
    transitionDuration: const Duration(milliseconds: 400),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .animate(animation),
        child: child,
      );
    },
  );
}

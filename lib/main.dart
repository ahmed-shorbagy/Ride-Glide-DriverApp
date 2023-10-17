import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ride_glide_driver_app/constants.dart';
import 'package:ride_glide_driver_app/core/errors/simple_bloc_observer.dart';
import 'package:ride_glide_driver_app/core/utils/App_router.dart';
import 'package:ride_glide_driver_app/core/utils/app_theme.dart';
import 'package:ride_glide_driver_app/core/utils/service_locator.dart';
import 'package:ride_glide_driver_app/features/auth/data/AuthRepo/authRepoImpl.dart';
import 'package:ride_glide_driver_app/features/auth/data/models/driver_Model.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/email_paswword_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/get_userData_cubit/get_user_data_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/phone_auth_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/user_cubit.dart';
import 'package:ride_glide_driver_app/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DriverModelAdapter());
  await Hive.openBox<DriverModel>(kDriverBox);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupServiceLocator();
  runApp(const RideGLideDriverApp());
  Bloc.observer = SimpleBLocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  debugPrint('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
}

class RideGLideDriverApp extends StatelessWidget {
  const RideGLideDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PhoneAuthCubit(AuthRepo()),
        ),
        BlocProvider(
          create: (context) => GetUserDataCubit(AuthRepo()),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => EmailPaswwordCubit(AuthRepo()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        theme: theme(),
      ),
    );
  }
}

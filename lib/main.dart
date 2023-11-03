import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:ride_glide_driver_app/constants.dart';
import 'package:ride_glide_driver_app/core/errors/simple_bloc_observer.dart';
import 'package:ride_glide_driver_app/core/utils/App_router.dart';
import 'package:ride_glide_driver_app/core/utils/app_theme.dart';
import 'package:ride_glide_driver_app/core/utils/methods.dart';
import 'package:ride_glide_driver_app/core/utils/service_locator.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/manager/Language_cubit/language_cubit.dart';
import 'package:ride_glide_driver_app/features/Home/peresentation/manager/Theme_provider/Theme_provider.dart';
import 'package:ride_glide_driver_app/features/auth/data/AuthRepo/authRepoImpl.dart';
import 'package:ride_glide_driver_app/features/auth/data/models/driver_Model.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/change_password_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/email_paswword_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/get_userData_cubit/get_user_data_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/get_userData_cubit/log_out_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/phone_auth_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/cubit/user_cubit.dart';
import 'package:ride_glide_driver_app/features/auth/peresentation/manager/delete_password_cubit/delete_password_cubit.dart';
import 'package:ride_glide_driver_app/firebase_options.dart';
import 'package:ride_glide_driver_app/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loadMapStyles();
  await Hive.initFlutter();
  Hive.registerAdapter(DriverModelAdapter());
  await Hive.openBox<DriverModel>(kDriverBox);

  setupServiceLocator();
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: const RideGLideDriverApp(),
  ));
  Bloc.observer = SimpleBLocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class RideGLideDriverApp extends StatelessWidget {
  const RideGLideDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PhoneAuthCubit(AuthRepo()),
        ),
        BlocProvider(
          create: (context) => LogOutCubit(),
        ),
        BlocProvider(
          create: (context) => GetUserDataCubit(AuthRepo()),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => ChangePasswordCubit(),
        ),
        BlocProvider(
          create: (context) => DeletePasswordCubit(),
        ),
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),
        BlocProvider(
          create: (context) => EmailPaswwordCubit(AuthRepo()),
        ),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          if (state is LanguageSuccess) {
            return MaterialApp.router(
              locale: state.local,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
              theme: lightTheme(),
              darkTheme: darkTheme(),
              themeMode: themeProvider.themeMode,
            );
          } else {
            return MaterialApp.router(
              locale: const Locale('en'),
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
              theme: lightTheme(),
              darkTheme: darkTheme(),
              themeMode: themeProvider.themeMode,
            );
          }
        },
      ),
    );
  }
}

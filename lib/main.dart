import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/firebase_options_dev.dart';
import 'package:restobillsplitter/firebase_options_prod.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/pages/assign_screen.dart';
import 'package:restobillsplitter/pages/dish_list_screen.dart';
import 'package:restobillsplitter/pages/guest_list_screen.dart';
import 'package:restobillsplitter/pages/home_screen.dart';
import 'package:restobillsplitter/pages/others_screen.dart';
import 'package:restobillsplitter/pages/privacy_policy_screen.dart';
import 'package:restobillsplitter/pages/summary_screen.dart';
import 'package:restobillsplitter/pages/terms_and_conditions_screen.dart';
import 'package:restobillsplitter/shared/adaptive_theme.dart';

// TODO app check + Missing google_app_id. Firebase Analytics disabled
void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    const String env = String.fromEnvironment('ENVIRONMENT', defaultValue: '');
    final FirebaseOptions firebaseOptions =
        _getFirebaseOptions(environment: env);
    await Firebase.initializeApp(
      options: firebaseOptions,
    );

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    Logger.level = Level.off; // off / debug

    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
  },
      (Object error, StackTrace stackTrace) => FirebaseCrashlytics.instance
          .recordError(error, stackTrace, fatal: true));
}

FirebaseOptions _getFirebaseOptions({required String environment}) {
  switch (environment) {
    case 'dev':
      return DevFirebaseOptions.currentPlatform;
    case 'prod':
      return ProdFirebaseOptions.currentPlatform;
    default:
      throw UnsupportedError(
        'FirebaseOptions are not supported for this environment.',
      );
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Logger logger = getLogger();
  final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

  // Set routes to use in Navigator
  final Map<String, Widget> routes = <String, Widget>{
    HomeScreen.routeName: const HomeScreen(),
    GuestListScreen.routeName: const GuestListScreen(),
    DishListScreen.routeName: const DishListScreen(),
    AssignScreen.routeName: AssignScreen(),
    OthersScreen.routeName: const OthersScreen(),
    SummaryScreen.routeName: const SummaryScreen(),
    PrivacyPolicyScreen.routeName: const PrivacyPolicyScreen(),
    TermsAndConditionsScreen.routeName: const TermsAndConditionsScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        // debugShowCheckedModeBanner: false,
        title: 'Resto Bill Splitter',
        theme: getAdaptiveThemeData(context),
        // home: HomeScreen(),
        // home: Scaffold(
        //   body: HomeScreen(),
        // ),
        home: const HomeScreen(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute<void>(
                builder: (BuildContext context) => const HomeScreen(),
              );
            default:
              return PageRouteBuilder<Widget>(
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) {
                  return routes[settings.name!]!;
                },
                transitionsBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  const Offset begin = Offset(0.0, 1.0);
                  const Offset end = Offset.zero;
                  const Cubic curve = Curves.ease;

                  final Animatable<Offset> tween =
                      Tween<Offset>(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );

                  // return FadeTransition(
                  //   opacity: animation,
                  //   child: child,
                  // );
                },
              );
          }
        },
        navigatorObservers: <NavigatorObserver>[
          FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
        ],
      ),
    );
  }
}

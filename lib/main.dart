import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/pages/assign_screen.dart';
import 'package:restobillsplitter/pages/dish_list_screen.dart';
import 'package:restobillsplitter/pages/guest_list_screen.dart';
import 'package:restobillsplitter/pages/home_screen.dart';
import 'package:restobillsplitter/pages/others_screen.dart';
import 'package:restobillsplitter/pages/privacy_policy_screen.dart';
import 'package:restobillsplitter/pages/summary_screen.dart';
import 'package:restobillsplitter/pages/terms_and_conditions_screen.dart';
import 'package:restobillsplitter/shared/adapative_progress_indicator.dart';
import 'package:restobillsplitter/shared/adaptive_theme.dart';

// Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
const bool _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
const bool _kTestingCrashlytics = false;

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    // Log level
    Logger.level = Level.nothing; // nothing / debug

    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
  }, (Object error, StackTrace stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Logger logger = getLogger();
  final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

  // Set routes to use in Navigator
  final Map<String, Widget> routes = <String, Widget>{
    HomeScreen.routeName: HomeScreen(),
    GuestListScreen.routeName: GuestListScreen(),
    DishListScreen.routeName: DishListScreen(),
    AssignScreen.routeName: AssignScreen(),
    OthersScreen.routeName: OthersScreen(),
    SummaryScreen.routeName: SummaryScreen(),
    PrivacyPolicyScreen.routeName: PrivacyPolicyScreen(),
    TermsAndConditionsScreen.routeName: TermsAndConditionsScreen(),
  };

  late Future<void> _initializeFlutterFireFuture;

  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      logger.d(list[100]);
    });
  }

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize

    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    if (_kShouldTestAsyncErrorOnInit) {
      await _testAsyncErrorOnInit();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeFlutterFireFuture = _initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        // debugShowCheckedModeBanner: false,
        title: 'Resto Bill Splitter',
        theme: getAdaptiveThemeData(context),
        // home: HomeScreen(),
        home: Scaffold(
          body: FutureBuilder<void>(
            future: _initializeFlutterFireFuture,
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return HomeScreen();
                default:
                  return Center(child: AdaptiveProgressIndicator());
              }
            },
          ),
        ),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute<void>(
                builder: (BuildContext context) => HomeScreen(),
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

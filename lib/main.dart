import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:restobillsplitter/pages/assign_screen.dart';
import 'package:restobillsplitter/pages/dish_list_screen.dart';
import 'package:restobillsplitter/pages/guest_list_screen.dart';
import 'package:restobillsplitter/pages/home_screen.dart';
import 'package:restobillsplitter/pages/others_screen.dart';
import 'package:restobillsplitter/pages/privacy_policy_screen.dart';
import 'package:restobillsplitter/pages/summary_screen.dart';
import 'package:restobillsplitter/pages/terms_and_conditions_screen.dart';
import 'package:restobillsplitter/shared/adaptive_theme.dart';

void main() {
  // TODO
  // LicenseRegistry.addLicense(() async* {
  //   final String license = await rootBundle.loadString('fonts/Raleway-OFL.txt');
  //   yield LicenseEntryWithLineBreaks(<String>['google_fonts'], license);
  // });

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookWidget {
  // final Logger logger = getLogger();
  // final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: "Rest\'O Bill Splitter",
        theme: getAdaptiveThemeData(context),
        home: HomeScreen(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute<void>(
                builder: (BuildContext context) => HomeScreen(),
              );
            default:
              return PageRouteBuilder<Widget>(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return routes[settings.name];
                },
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) {
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
        // navigatorObservers: <NavigatorObserver>[
        //   FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
        // ],
      ),
    );
  }
}

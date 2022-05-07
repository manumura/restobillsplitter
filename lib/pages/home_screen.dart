import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/pages/assign_screen.dart';
import 'package:restobillsplitter/pages/dish_list_screen.dart';
import 'package:restobillsplitter/pages/guest_list_screen.dart';
import 'package:restobillsplitter/pages/others_screen.dart';
import 'package:restobillsplitter/pages/summary_screen.dart';

class HomeScreen extends StatefulHookWidget {
  static const String routeName = '/';

  @override
  _HomeScreenScreenState createState() => _HomeScreenScreenState();
}

class _HomeScreenScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  PageController? _pageController;

  final Logger logger = getLogger();

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          // drawer: SideDrawer(),
          // appBar: AppBar(
          //   title: const Text('Title'),
          //   elevation:
          //       Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          //   actions: <Widget>[
          //     _buildChip(orders$),
          //     _buildCsvExportButton(orderBloc),
          //     LogoutButton(),
          //   ],
          // ),
          body: PageView(
            // physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              GuestListScreen(),
              DishListScreen(),
              AssignScreen(),
              OthersScreen(),
              SummaryScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (int index) {
              _pageController!.animateToPage(
                index,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 100),
              );
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.userPen),
                label: 'Guests',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.utensils),
                label: 'Dishes',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.peopleArrowsLeftRight),
                label: 'Assign',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.wallet),
                label: 'Others',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.dollarSign),
                label: 'Summary',
              ),
            ],
            elevation: 10.0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.grey[500],
            selectedFontSize: 16.0,
            selectedIconTheme: const IconThemeData(size: 30.0),
          ),
        ),
      ),
    );
  }
}

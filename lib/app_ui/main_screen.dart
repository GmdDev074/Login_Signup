import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:Lecture_Scheduler/app_ui/home_view.dart';
import 'package:Lecture_Scheduler/app_ui/schedule_with_calendar_view.dart';
import 'package:Lecture_Scheduler/app_ui/subjects_view.dart';
import 'package:Lecture_Scheduler/app_ui/info_view.dart';
import 'package:Lecture_Scheduler/app_ui/privacy_policy_view.dart';
import 'package:Lecture_Scheduler/app_ui/terms_and_conditions_view.dart';
import 'package:Lecture_Scheduler/app_ui/rate_us_view.dart';
import 'package:Lecture_Scheduler/app_ui/support_view.dart';
import 'package:Lecture_Scheduler/app_ui/contact_us_view.dart';
import 'package:Lecture_Scheduler/app_ui/how_to_use_view.dart';
import '../controllers/login_controller.dart';
import '../controllers/profile_controller.dart';

class UserModel {
  final String name;
  final String number;
  final String email;
  final String uid;

  UserModel({
    required this.name,
    required this.number,
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'email': email,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      number: map['number'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
    );
  }
}

class DrawerStateManager {
  final GlobalKey<ScaffoldState> scaffoldKey;

  DrawerStateManager(this.scaffoldKey);

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer(BuildContext context) {
    Navigator.of(context).pop();
  }

  bool isDrawerOpen() {
    return scaffoldKey.currentState?.isDrawerOpen ?? false;
  }
}

// Custom fade transition
class FadePageRoute<T> extends MaterialPageRoute<T> {
  FadePageRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late DrawerStateManager _drawerManager;
  late ProfileController _profileController;
  String? _name;
  bool _hasError = false;

  // Variables for double back press
  DateTime? _lastPressedAt;

  final List<Widget> _views = [
    const HomeView(),
    const ScheduleWithCalendarViewView(),
    const SubjectsView(),
    const InfoView(),
  ];

  String get _appBarTitle {
    switch (_selectedIndex) {
      case 0:
        return 'Subjects & Schedules';
      case 1:
        return 'Schedules';
      case 2:
        return 'Subjects';
      case 3:
        return 'Profile';
      default:
        return 'Subjects & Schedules';
    }
  }

  // Determines if the app is running on web or desktop
  bool get isWebOrDesktop => kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  @override
  void initState() {
    super.initState();
    _drawerManager = DrawerStateManager(_scaffoldKey);
    _profileController = ProfileController();
    _checkUserAndFetchData();
  }

  Future<void> _checkUserAndFetchData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, 'login');
      });
      return;
    }

    try {
      final userData = await _profileController.getUserData(user.uid);
      if (userData != null) {
        setState(() {
          _name = userData.name;
        });
      } else {
        setState(() {
          _hasError = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found')),
        );
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Handle double back press
  Future<bool> _onWillPop() async {
    // If drawer is open, close it and prevent app exit
    if (_drawerManager.isDrawerOpen()) {
      _drawerManager.closeDrawer(context);
      return false;
    }

    // Check for double back press
    final now = DateTime.now();
    const duration = Duration(seconds: 2);

    if (_lastPressedAt == null || now.difference(_lastPressedAt!) > duration) {
      _lastPressedAt = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return false; // Prevent exit
    }

    // Exit the app
    await SystemNavigator.pop(); // Closes the app
    return true;
  }

  // Build the drawer content
  Widget _buildDrawerContent(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _name ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.black),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            onTap: () {
              _drawerManager.closeDrawer(context);
              Navigator.push(
                context,
                FadePageRoute(
                  builder: (context) => const PrivacyPolicyView(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description, color: Colors.black),
            title: const Text(
              'Terms and Conditions',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            onTap: () {
              _drawerManager.closeDrawer(context);
              Navigator.push(
                context,
                FadePageRoute(
                  builder: (context) => const TermsAndConditionsView(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.star, color: Colors.black),
            title: const Text(
              'Rate Us',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            onTap: () {
              _drawerManager.closeDrawer(context);
              Navigator.push(
                context,
                FadePageRoute(
                  builder: (context) => const RateUsView(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.support, color: Colors.black),
            title: const Text(
              'Support',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            onTap: () {
              _drawerManager.closeDrawer(context);
              Navigator.push(
                context,
                FadePageRoute(
                  builder: (context) => const SupportView(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail, color: Colors.black),
            title: const Text(
              'Contact Us',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            onTap: () {
              _drawerManager.closeDrawer(context);
              Navigator.push(
                context,
                FadePageRoute(
                  builder: (context) => const ContactUsView(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.black),
            title: const Text(
              'How to Use',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            onTap: () {
              _drawerManager.closeDrawer(context);
              Navigator.push(
                context,
                FadePageRoute(
                  builder: (context) => const HowToUseView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = LoginController();
    return WillPopScope(
      onWillPop: _onWillPop, // Intercept back button
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.menu),
            onPressed: _drawerManager.openDrawer,
          ),
          backgroundColor: Colors.black,
          title: Text(
            _appBarTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            if (_selectedIndex == 3)
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await loginController.logout(context);
                },
              ),
          ],
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * (isWebOrDesktop ? 0.3 : 0.8), //80% for mobile and 30% for the desktop or web
          child: _buildDrawerContent(context),
        ),
        body: isWebOrDesktop
            ? Row(
          children: [
            Expanded(
              child: _views[_selectedIndex], // Main content
            ),
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: Colors.black87,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(-5, 0),
                  ),
                ],
              ),
              child: NavigationRail(
                backgroundColor: Colors.transparent,
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onItemTapped,
                labelType: NavigationRailLabelType.none,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home, color: Colors.grey),
                    selectedIcon: Icon(Icons.home, color: Colors.orange),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.schedule, color: Colors.grey),
                    selectedIcon: Icon(Icons.schedule, color: Colors.orange),
                    label: Text('Schedule'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.subject, color: Colors.grey),
                    selectedIcon: Icon(Icons.subject, color: Colors.orange),
                    label: Text('Subjects'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person, color: Colors.grey),
                    selectedIcon: Icon(Icons.person, color: Colors.orange),
                    label: Text('Profile'),
                  ),
                ],
                useIndicator: false,
              ),
            ),
          ],
        )
            : _views[_selectedIndex], // Mobile: Full-screen content
        bottomNavigationBar: isWebOrDesktop
            ? null
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.schedule),
                  label: 'Schedule',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.subject),
                  label: 'Subjects',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.transparent,
              elevation: 0,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              iconSize: 28,
            ),
          ),
        ),
      ),
    );
  }
}
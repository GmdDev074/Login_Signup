import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Lecture_Scheduler/app_ui/home_view.dart';
import 'package:Lecture_Scheduler/app_ui/schedule_with_calendar_view.dart';
import 'package:Lecture_Scheduler/app_ui/info_view.dart';
import 'package:Lecture_Scheduler/app_ui/subjects_view.dart';
import 'package:flutter/services.dart';
import '../controllers/login_controller.dart';
import '../controllers/profile_controller.dart';
import 'dart:io'; // For SystemNavigator.pop()

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
  bool _isLoading = true;

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
        return 'Schedule';
      case 1:
        return 'Schedule';
      case 2:
        return 'Subjects';
      case 3:
        return 'Profile';
      default:
        return 'Schedule';
    }
  }

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
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }

    try {
      final userData = await _profileController.getUserData(user.uid);
      if (userData != null) {
        setState(() {
          _name = userData.name;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
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

    if (_lastPressedAt == null ||
        now.difference(_lastPressedAt!) > duration) {
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final LoginController loginController = LoginController();
    return WillPopScope(
      onWillPop: _onWillPop, // Intercept back button
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _drawerManager.openDrawer,
          ),
          backgroundColor: Colors.green.shade700,
          title: Text(_appBarTitle),
          actions: [
            if (_selectedIndex == 3)
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await loginController.logout(context);
                },
              ),
          ],
        ),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.85,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
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
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                onTap: () {
                  _drawerManager.closeDrawer(context);
                  Navigator.pushNamed(context, '/privacy_policy');
                },
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Terms and Conditions'),
                onTap: () {
                  _drawerManager.closeDrawer(context);
                  Navigator.pushNamed(context, '/terms_and_conditions');
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Rate Us'),
                onTap: () {
                  _drawerManager.closeDrawer(context);
                  Navigator.pushNamed(context, '/rate_us');
                },
              ),
              ListTile(
                leading: const Icon(Icons.support),
                title: const Text('Support'),
                onTap: () {
                  _drawerManager.closeDrawer(context);
                  Navigator.pushNamed(context, '/support');
                },
              ),
              ListTile(
                leading: const Icon(Icons.contact_mail),
                title: const Text('Contact Us'),
                onTap: () {
                  _drawerManager.closeDrawer(context);
                  Navigator.pushNamed(context, '/contact_us');
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('How to Use'),
                onTap: () {
                  _drawerManager.closeDrawer(context);
                  Navigator.pushNamed(context, '/how_to_use');
                },
              ),
            ],
          ),
        ),
        body: _views[_selectedIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.schedule,
                    color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                  ),
                  label: 'Schedule',
                  backgroundColor: _selectedIndex == 1 ? Colors.green.shade700 : Colors.transparent,
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.subject),
                  label: 'Subjects',
                ),
                const BottomNavigationBarItem(
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
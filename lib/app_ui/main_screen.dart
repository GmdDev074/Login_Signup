import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Lecture_Scheduler/app_ui/home_view.dart';
import 'package:Lecture_Scheduler/app_ui/listen_view.dart';
import 'package:Lecture_Scheduler/app_ui/info_view.dart';
import 'package:Lecture_Scheduler/app_ui/subjects_view.dart';
import '../controllers/login_controller.dart';
import '../controllers/profile_controller.dart';

// UserModel class as provided
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

// Custom DrawerStateManager to control drawer operations
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
  String? _name; // Store the fetched name
  bool _isLoading = true; // Track loading state

  // List of views for each tab
  final List<Widget> _views = [
    const HomeView(),
    const ListenView(),
    const SubjectsView(),
    const InfoView(),
  ];

  // Map the selected index to the corresponding AppBar title
  String get _appBarTitle {
    switch (_selectedIndex) {
      case 0:
        return 'Schedule'; // Home view
      case 1:
        return 'Schedule'; // Listen view
      case 2:
        return 'Subjects'; // Subjects view
      case 3:
        return 'Profile'; // Info view
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

  // Check if user is logged in and fetch user data
  Future<void> _checkUserAndFetchData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If no user is logged in, redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, 'login');
      });
      return;
    }

    try {
      final userData = await _profileController.getUserData(user.uid);
      if (userData != null) {
        setState(() {
          _name = userData.name; // Use the 'name' field from UserModel
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

  @override
  Widget build(BuildContext context) {
    // Show a loading screen if user data is still being fetched
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final LoginController loginController = LoginController();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: _drawerManager.openDrawer,
        ),
        title: Text(
          _appBarTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          if (_selectedIndex == 3) // Show logout button only on Info view (Profile)
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () async {
                await loginController.logout(context);
              },
            ),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        backgroundColor: Colors.white,
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
                  const SizedBox(width: 16), // Space between avatar and name
                  Expanded(
                    child: Text(
                      _name ?? 'User', // Display fetched name or fallback
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
              leading: const Icon(
                Icons.privacy_tip,
                color: Colors.black,
              ),
              title: const Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                _drawerManager.closeDrawer(context);
                // Add navigation or action for Privacy Policy
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.description,
                color: Colors.black,
              ),
              title: const Text(
                'Terms and Conditions',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                _drawerManager.closeDrawer(context);
                // Add navigation or action for Terms and Conditions
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.star,
                color: Colors.black,
              ),
              title: const Text(
                'Rate Us',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                _drawerManager.closeDrawer(context);
                // Add navigation or action for Rate Us
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.support,
                color: Colors.black,
              ),
              title: const Text(
                'Support',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                _drawerManager.closeDrawer(context);
                // Add navigation or action for Support
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.contact_mail,
                color: Colors.black,
              ),
              title: const Text(
                'Contact Us',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                _drawerManager.closeDrawer(context);
                // Add navigation or action for Contact Us
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.help,
                color: Colors.black,
              ),
              title: const Text(
                'How to Use',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                _drawerManager.closeDrawer(context);
                // Add navigation or action for How to Use
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
    );
  }
}
import 'package:flutter/material.dart';
import 'package:test_app/app_ui/home_view.dart';
import 'package:test_app/app_ui/listen_view.dart';
import 'package:test_app/app_ui/info_view.dart';
import 'package:test_app/app_ui/subjects_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of views for each tab
  final List<Widget> _views = [
    const HomeView(),
    const ListenView(),
    const SubjectsView(),
    const InfoView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black87, // Dark background like in the image
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
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule),
                label: 'Schedules',
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
            selectedItemColor: Colors.orange, // Orange for selected item
            unselectedItemColor: Colors.grey, // Grey for unselected items
            backgroundColor: Colors.transparent, // Transparent to use container's color
            elevation: 0, // Remove default shadow
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true, // Hide labels as in the image
            showUnselectedLabels: false,
            iconSize: 28, // Slightly larger icons
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';


class navigation_bar extends StatefulWidget {
  const navigation_bar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<navigation_bar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [Home()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: const Color(0xFF0F3446),
        unselectedItemColor: const Color(0xFF0F3446),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
            backgroundColor: const Color(0xFFE9EDF5),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            activeIcon: Icon(Icons.fastfood_rounded),
            label: 'Meals',
            backgroundColor: const Color(0xFFE9EDF5),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            activeIcon: Icon(Icons.tv),
            label: 'Appointments',
            backgroundColor: const Color(0xFFE9EDF5),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency_outlined),
            activeIcon: Icon(Icons.emergency),
            label: 'Emergency',
            backgroundColor: const Color(0xFFE9EDF5),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
            backgroundColor: const Color(0xFFE9EDF5),
          ),
        ],
      ),
    );
  }

  static Home() {}
}
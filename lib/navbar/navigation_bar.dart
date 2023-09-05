import 'package:flutter/material.dart';


import '../screens/Store.dart';
import '../screens/cart.dart';
import '../screens/find_doctors.dart';
import '../screens/home.dart';
import '../screens/patient_profile.dart';
import '../screens/product_category.dart';


class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [HomeScreen(),YourWidget(),MyComponent(),CartScreen(),PatientProfile(),ProductCategoryFormApp()];

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
            icon:Icon(Icons.home),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
            backgroundColor: const Color(0xFFE9EDF5),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room_outlined),
            activeIcon: Icon(Icons.meeting_room_outlined),
            label: 'Appoinment',
            backgroundColor: const Color(0xFFE9EDF5),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop_2),
            activeIcon: Icon(Icons.shop_2),
            label: 'Shop',
            backgroundColor: const Color(0xFFE9EDF5),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
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
}

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cycle_screen.dart';
import 'wellness_screen.dart';
import 'shop_screen.dart';
import 'profile_screen.dart';
import '../theme/app_colors.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CycleScreen(),
    const WellnessScreen(),
    const ShopScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Cycle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wellness',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopify),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.deepPlum,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppColors.pearlWhite,
        onTap: _onItemTapped,
      ),
    );
  }
}
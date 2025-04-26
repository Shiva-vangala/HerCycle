import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cycle_screen.dart';
import 'wellness_screen.dart';
import 'shop_screen.dart';
import 'profile_screen.dart';
import 'top_nav.dart';
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

  void _updateTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: TopNav(onTabSelected: _updateTab), // Pass the callback to TopNav
      drawer: isSmallScreen ? const TopNavDrawer() : null,
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
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.deepPlum,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: AppColors.pearlWhite,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Serif',
          fontSize: isSmallScreen ? 12 : 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Serif',
          fontSize: isSmallScreen ? 11 : 12,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedIconTheme: IconThemeData(
          size: isSmallScreen ? 24 : 28,
        ),
        unselectedIconTheme: IconThemeData(
          size: isSmallScreen ? 20 : 24,
        ),
        onTap: _onItemTapped,
      ),
    );
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'navigations/consumer_aboutus_screen.dart';
import 'navigations/consumer_claim_screen.dart';
import 'navigations/consumer_home_screen.dart';
import 'navigations/consumer_new_arrivals_screen.dart';
import 'navigations/consumer_profile_screen.dart';

class ConsumerDashboard extends StatefulWidget {
  @override
  State<ConsumerDashboard> createState() => _ConsumerDashboardState();
}

class _ConsumerDashboardState extends State<ConsumerDashboard> {
  int _currentIndex = 0;
  final List<String> _titles = ['Home','New Arrivals','Claim','Profile','About Us'];
  final List<Widget> _screens = [
    ConsumerHomeScreen(),
    ConsumerNewArrivalsScreen(),
    ConsumerClaimScreen(),
    ConsumerProfileScreen(),
    ConsumerAboutusScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(screenWidth),
    );
  }

  BottomNavigationBarItem _bottomNavBarItem({
    required IconData iconData,
    required String label,
  }) {
    return BottomNavigationBarItem(icon: Icon(iconData), label: label);
  }

  Widget _buildBottomNavigationBar(double screenWidth){
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        // iconSize: screenWidth * 0.05,
        // selectedFontSize: screenWidth* 0.03,
        // unselectedFontSize: screenWidth* 0.03,
        selectedItemColor: CustColors.nile_blue,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        elevation: 30,
        items: [
          _bottomNavBarItem(label: 'Home', iconData: Icons.home),
          _bottomNavBarItem(label: 'New Arrivals', iconData: Icons.inventory_2),
          _bottomNavBarItem(label: 'Claims', iconData: Icons.receipt_long),
          _bottomNavBarItem(label: 'Profile', iconData: Icons.person),
          _bottomNavBarItem(label: 'About Us', iconData: Icons.business),
        ]);
  }
}


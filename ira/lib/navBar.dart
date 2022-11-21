import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ira/auth/home.dart';
import 'package:ira/constants.dart';
import 'package:ira/maps/addReport.dart';
import 'package:ira/maps/maps.dart';
import 'package:ira/profile/profile.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    MapScreen(),
    Text(
      'Notification Page',
      style: optionStyle,
    ),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        //margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
        decoration: const BoxDecoration(
          color: Colors.blueGrey,
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(20),
          //   topRight: Radius.circular(20),
          // ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: GNav(
              rippleColor: AppColors.grey[300]!,
              hoverColor: AppColors.grey[100]!,
              gap: 8,
              activeColor: AppColors.blueAccent,
              iconSize: 20,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.white,
              color: AppColors.white,
              textStyle: AppTextStyles.subtitle.copyWith(
                color: AppColors.blueAccent,
              ),
              tabBorderRadius: 10,
              tabs: const [
                GButton(
                  icon: Icons.home_rounded,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.location_pin,
                  text: 'iMap',
                ),
                GButton(
                  icon: Icons.notifications,
                  text: 'Notifications',
                ),
                GButton(
                  icon: Icons.person_rounded,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
      // bottomNavigationBar: FloatingNavbar(
      //   onTap: (index) => setState(() {
      //     _selectedIndex = index;
      //   }),
      //   currentIndex: _selectedIndex,
      //   items: [
      //     FloatingNavbarItem(icon: Icons.home),
      //     FloatingNavbarItem(icon: Icons.bar_chart),
      //     FloatingNavbarItem(icon: Icons.person),
      //   ],
      //   selectedItemColor: Colors.red,
      //   unselectedItemColor: Colors.white,
      //   backgroundColor: Colors.blue,
      //   itemBorderRadius: 15,
      //   borderRadius: 20,
      //   iconSize: 20,
      // ),
    );
  }
}

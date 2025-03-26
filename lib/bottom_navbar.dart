import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:dashboard/audioBook_view.dart';
import 'package:dashboard/my_books.dart';
import 'package:dashboard/profile_screen.dart';
import 'package:dashboard/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'collection.dart';
import 'dashboard.dart';
class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final NotchBottomBarController _controller = NotchBottomBarController();
  final themeController = Get.find<ThemeController>();


  // Track the current index
  int _currentIndex = 0;





  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Scaffold(
        backgroundColor: themeController.isDarkTheme.value ? Colors.black : Colors.white,
      body:  IndexedStack(
        index: _currentIndex,
        children: [
          Dashboard(),
          Collection(),
          AudiobookListScreen(), // Placeholder for mybooks
          ProfileScreen(), // Placeholder for Profile
        ],
      ),

      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Colors.white,
        showLabel: true,
        textOverflow: TextOverflow.visible,
        maxLine: 1,
        shadowElevation: 5,
        kBottomRadius: 28.0,
        notchColor: Colors.black87,
        removeMargins: false,
        bottomBarWidth: MediaQuery.of(context).size.width,
        showShadow: false,
        durationInMilliSeconds: 300,
        itemLabelStyle: const TextStyle(fontSize: 10),
        elevation: 1,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(
              Icons.home_filled,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.home_filled,
              color: Colors.blueAccent,
            ),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.star, color: Colors.blueGrey),
            activeItem: Icon(
              Icons.star,
              color: Colors.blueAccent,
            ),
            itemLabel: 'Collection',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.settings,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.settings,
              color: Colors.pink,
            ),
            itemLabel: 'Settings',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.person,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.person,
              color: Colors.yellow,
            ),
            itemLabel: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index to show the new page
          });

        },
        kIconSize: 24.0,

      ),
    );
  }
}
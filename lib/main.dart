
import 'package:dashboard/bottom_navbar.dart';
import 'package:dashboard/dashboard.dart';
import 'package:dashboard/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures plugins are loaded

  Get.put(ThemeController()); // Initialize ThemeController

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeController.isDarkTheme.value
          ? ThemeData.dark()
          : ThemeData.light(),
      home: BottomNavbar(),
    ));
  }
}



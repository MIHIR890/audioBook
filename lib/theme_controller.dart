import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  RxBool isDarkTheme = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPreferences();
  }

  Future<void> _loadThemeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkTheme.value = prefs.getBool('isDarkTheme') ?? false;
  }

  Future<void> toggleTheme() async {
    isDarkTheme.value = !isDarkTheme.value; // Update the theme dynamically
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDarkTheme.value);
  }
}

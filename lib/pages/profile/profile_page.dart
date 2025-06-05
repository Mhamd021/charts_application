import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> saveLanguagePreference(String langCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', langCode);
  }

  void changeLanguage(String langCode) {
    Get.updateLocale(Locale(langCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'.tr)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('select_language'.tr),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                saveLanguagePreference('en');
                changeLanguage('en');
              },
              child: const Text('English'),
            ),
            ElevatedButton(
              onPressed: () {
                saveLanguagePreference('ar');
                changeLanguage('ar');
              },
              child: const Text('العربية'),
            ),
          ],
        ),
      ),
    );
  }
}

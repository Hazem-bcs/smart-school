import 'package:flutter/material.dart';
import 'app_routes.dart';

extension NavigationExtension on BuildContext {
  // Navigate to splash page
  void goToSplash() {
    Navigator.pushReplacementNamed(this, AppRoutes.splash);
  }
  
  // Navigate to login page
  void goToLogin() {
    Navigator.pushReplacementNamed(this, AppRoutes.login);
  }
  
  // Navigate to classes page
  void goToClasses() {
    Navigator.pushReplacementNamed(this, AppRoutes.classes);
  }
  
  // Navigate to home page with class name
  void goToHome({required String className}) {
    Navigator.pushReplacementNamed(
      this,
      AppRoutes.home,
      arguments: {'className': className},
    );
  }
  
  // Navigate to profile page
  void goToProfile() {
    Navigator.pushNamed(this, AppRoutes.profile);
  }
  
  // Navigate to settings page
  void goToSettings() {
    Navigator.pushNamed(this, AppRoutes.settings);
  }
  
  // Go back
  void goBack() {
    if (Navigator.canPop(this)) {
      Navigator.pop(this);
    }
  }
} 
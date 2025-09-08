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
  

  
  // Navigate to home page with class name
  void goToHome() {
    Navigator.pushReplacementNamed(
      this,
      AppRoutes.home,
    );
  }
  
  // Navigate to profile page
  void goToProfile() {
    Navigator.pushNamed(this, AppRoutes.profile);
  }
  
  // Navigate to edit profile page
  void goToEditProfile() {
    Navigator.pushNamed(this, AppRoutes.editProfile);
  }
  
  // Navigate to settings page
  void goToSettings() {
    Navigator.pushNamed(this, AppRoutes.settings);
  }
  
  // Navigate to schedule page
  void goToSchedule() {
    Navigator.pushNamed(this, AppRoutes.schedule);
  }
  
  // Go back
  void goBack() {
    if (Navigator.canPop(this)) {
      Navigator.pop(this);
    }
  }

  void goToAssignmentSubmission(String assignmentId) {
    Navigator.pushNamed(this, AppRoutes.assignmentSubmission, arguments: assignmentId);
  }

  void goToNewAssignment() {
    Navigator.pushNamed(this, AppRoutes.newAssignment);
  }

  // Navigate to about app page
  void goToAboutApp() {
    Navigator.pushNamed(this, AppRoutes.aboutApp);
  }

  // Navigate to help FAQ page
  void goToHelpFaq() {
    Navigator.pushNamed(this, AppRoutes.helpFaq);
  }

  void pushReplacementAllNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
  }

  // Navigate to students list page
  void goToStudentsList() {
    Navigator.pushNamed(this, AppRoutes.studentsList);
  }

  // Navigate to student achievements page
  void goToStudentAchievements(String studentId, String studentName) {
    Navigator.pushNamed(
      this,
      AppRoutes.studentAchievements,
      arguments: {
        'studentId': studentId,
        'studentName': studentName,
      },
    );
  }
} 
import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../features/new_assignment/domain/entities/assignment_entity.dart';

/// Navigation extension for easy navigation throughout the app
extension NavigationExtension on BuildContext {
  // Core navigation methods
  void goToSplash() {
    Navigator.pushReplacementNamed(this, AppRoutes.splash);
  }
  
  void goToOnBoarding() {
    Navigator.pushReplacementNamed(this, AppRoutes.onBoarding);
  }
  
  void goToLogin() {
    Navigator.pushReplacementNamed(this, AppRoutes.login);
  }
  
  void goToHome() {
    Navigator.pushReplacementNamed(this, AppRoutes.home);
  }
  
  // Feature navigation methods
  void goToHomework() {
    Navigator.pushNamed(this, AppRoutes.homework);
  }
  
  void goToDues() {
    Navigator.pushNamed(this, AppRoutes.dues);
  }
  
  void goToProfile() {
    Navigator.pushNamed(this, AppRoutes.profile);
  }
  
  void goToSubjects() {
    Navigator.pushNamed(this, AppRoutes.subjects);
  }
  
  void goToSubjectDetails(int subjectId) {
    Navigator.pushNamed(
      this, 
      AppRoutes.subjectDetails,
      arguments: subjectId,
    );
  }
  
  void goToTeachers() {
    Navigator.pushNamed(this, AppRoutes.teachers);
  }
  
  void goToTeacherDetails(int teacherId) {
    Navigator.pushNamed(
      this, 
      AppRoutes.teacherDetails,
      arguments: teacherId,
    );
  }
  
  void goToNotifications() {
    Navigator.pushNamed(this, AppRoutes.notifications);
  }
  
  void goToResources() {
    Navigator.pushNamed(this, AppRoutes.resources);
  }
  
  void goToSettings() {
    Navigator.pushNamed(this, AppRoutes.settingsPage);
  }
  
  void goToSchedule() {
    Navigator.pushNamed(this, AppRoutes.schedule);
  }
  
  void goToAssignments() {
    Navigator.pushNamed(this, AppRoutes.assignments);
  }
  
  void goToAssignmentDetails(AssignmentEntity assignment) {
    Navigator.pushNamed(
      this, 
      AppRoutes.assignmentDetails,
      arguments: assignment,
    );
  }
  
  void goToQuestions(String questionId) {
    Navigator.pushNamed(
      this, 
      AppRoutes.questions,
      arguments: questionId,
    );
  }
  
  void goToTutorChat() {
    Navigator.pushNamed(this, AppRoutes.tutorChat);
  }
  
  void goToAttendance() {
    Navigator.pushNamed(this, AppRoutes.attendance);
  }
  
  void goToZoom() {
    Navigator.pushNamed(this, AppRoutes.zoom);
  }
  
  // Settings sub-navigation
  void goToAboutApp() {
    Navigator.pushNamed(this, AppRoutes.aboutApp);
  }
  
  void goToHelpFaq() {
    Navigator.pushNamed(this, AppRoutes.helpFaq);
  }
  
  // Navigation drawer
  void goToAppDrawer() {
    Navigator.pushNamed(this, AppRoutes.appDrawer);
  }
  
  // Utility navigation methods
  void goBack() {
    if (Navigator.canPop(this)) {
      Navigator.pop(this);
    }
  }
  
  /// Navigate and remove all previous routes
  void pushReplacementAllNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamedAndRemoveUntil(
      routeName, 
      (route) => false, 
      arguments: arguments,
    );
  }
  
  /// Navigate to home and remove all previous routes
  void goToHomeAndClearStack() {
    pushReplacementAllNamed(AppRoutes.home);
  }
  
  /// Navigate to login and remove all previous routes
  void goToLoginAndClearStack() {
    pushReplacementAllNamed(AppRoutes.login);
  }
  
  /// Navigate to splash and remove all previous routes
  void goToSplashAndClearStack() {
    pushReplacementAllNamed(AppRoutes.splash);
  }
  
  /// Navigate to onboarding and remove all previous routes
  void goToOnBoardingAndClearStack() {
    pushReplacementAllNamed(AppRoutes.onBoarding);
  }
} 
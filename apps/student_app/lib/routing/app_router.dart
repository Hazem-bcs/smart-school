import 'package:flutter/material.dart';
import 'app_routes.dart';

/// Centralized router management for Smart School Student App
class AppRouter {
  /// Generate route with proper error handling
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return AppRoutes.generateRoute(settings);
  }
  
  /// Check if route exists
  static bool routeExists(String routeName) {
    switch (routeName) {
      case AppRoutes.splash:
      case AppRoutes.onBoarding:
      case AppRoutes.login:
      case AppRoutes.home:
      case AppRoutes.homework:
      case AppRoutes.dues:
      case AppRoutes.profile:
      case AppRoutes.subjects:
      case AppRoutes.teachers:
      case AppRoutes.notifications:
      case AppRoutes.resources:
      case AppRoutes.settingsPage:
      case AppRoutes.schedule:
      case AppRoutes.assignments:
      case AppRoutes.assignmentDetails:
      case AppRoutes.tutorChat:
      case AppRoutes.attendance:
      case AppRoutes.zoom:
      case AppRoutes.aboutApp:
      case AppRoutes.helpFaq:
      case AppRoutes.appDrawer:
        return true;
      default:
        return false;
    }
  }
  
  /// Check if route requires authentication
  static bool requiresAuthentication(String routeName) {
    switch (routeName) {
      case AppRoutes.splash:
      case AppRoutes.onBoarding:
      case AppRoutes.login:
        return false;
      default:
        return true;
    }
  }
  
  /// Check if route is a main feature route
  static bool isMainFeatureRoute(String routeName) {
    switch (routeName) {
      case AppRoutes.home:
      case AppRoutes.homework:
      case AppRoutes.dues:
      case AppRoutes.profile:
      case AppRoutes.subjects:
      case AppRoutes.teachers:
      case AppRoutes.notifications:
      case AppRoutes.resources:
      case AppRoutes.schedule:
      case AppRoutes.assignments:
      case AppRoutes.tutorChat:
      case AppRoutes.attendance:
      case AppRoutes.zoom:
        return true;
      default:
        return false;
    }
  }
  
  /// Check if route is a settings route
  static bool isSettingsRoute(String routeName) {
    switch (routeName) {
      case AppRoutes.settingsPage:
      case AppRoutes.aboutApp:
      case AppRoutes.helpFaq:
        return true;
      default:
        return false;
    }
  }
}
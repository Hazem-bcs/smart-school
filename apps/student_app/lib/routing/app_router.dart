class AppRoutes {
  // المسارات الأساسية
  static const String splash = '/splash';
  static const String boarding = '/boarding';

  // مسارات المصادقة (Authentication)
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // مسارات الصفحة الرئيسية (Home)
  static const String home = '/home';
  static const String notifications = 'notifications'; // مسار فرعي من home

  // مسارات الملف الشخصي (Profile)
  static const String profile = '/profile'; // سيأخذ ID كـ parameter
  static const String editProfile = '/edit-profile';

  // مسارات الإعدادات (Settings)
  static const String settings = '/settings';
  static const String language = '/settings/language';
}
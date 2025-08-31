# 🚀 Smart School Student App - Routing System

## 📋 Overview

This directory contains the centralized routing system for the Smart School Student App, following Clean Architecture principles and professional Flutter development practices.

## 🏗️ Architecture

### File Structure
```
routing/
├── index.dart              # Main export file
├── app_routes.dart         # Route constants and generation logic
├── app_router.dart         # Router utilities and route management
├── navigation_extension.dart # Navigation helper methods
└── README.md              # This documentation
```

## 🔧 Components

### 1. AppRoutes (`app_routes.dart`)
- **Purpose**: Defines all route constants and generates routes with proper BLoC initialization
- **Features**:
  - Centralized route constants
  - Automatic BLoC provider setup
  - Error handling for unknown routes
  - Support for route arguments

### 2. AppRouter (`app_router.dart`)
- **Purpose**: Provides essential utility methods for route management
- **Features**:
  - Route validation
  - Route categorization (main features, settings, etc.)
  - Authentication requirements checking

### 3. NavigationExtension (`navigation_extension.dart`)
- **Purpose**: Extension methods for easy navigation throughout the app
- **Features**:
  - Simple navigation methods (e.g., `context.goToHome()`)
  - Stack management methods
  - Type-safe navigation with arguments

## 📱 Available Routes

### Core Routes
- `/splash` - Splash screen
- `/onBoarding` - Onboarding flow
- `/login` - Authentication
- `/home` - Main dashboard

### Feature Routes
- `/homework` - Homework management
- `/dues` - Financial dues
- `/profile` - User profile
- `/subjects` - Subject list
- `/teachers` - Teacher directory
- `/notifications` - Notifications center
- `/resources` - Educational resources
- `/schedule` - Class schedule
- `/assignments` - Assignment list
- `/assignment_details` - Assignment details
- `/tutorChat` - AI tutor chat
- `/attendance` - Attendance tracking
- `/zoom` - Zoom meetings

### Settings Routes
- `/settings` - Main settings
- `/about-app` - App information
- `/help-faq` - Help and FAQ

## 🚀 Usage Examples

### Basic Navigation
```dart
// Navigate to a page
context.goToHome();
context.goToProfile();
context.goToSettings();

// Navigate with arguments
context.goToAssignmentDetails(assignment);

// Navigate and clear stack
context.goToHomeAndClearStack();
```

### Route Generation
```dart
// In MaterialApp
MaterialApp(
  onGenerateRoute: AppRouter.generateRoute,
  // ... other properties
)
```

### Route Validation
```dart
// Check if route exists
if (AppRouter.routeExists('/home')) {
  // Route is valid
}

// Check if route requires authentication
if (AppRouter.requiresAuthentication('/profile')) {
  // Show login prompt
}

// Check route type
if (AppRouter.isMainFeatureRoute('/homework')) {
  // Main feature route
}

if (AppRouter.isSettingsRoute('/settings')) {
  // Settings route
}
```

## 🔒 BLoC Integration

Each route automatically initializes the required BLoC providers:

```dart
case AppRoutes.homework:
  return MaterialPageRoute(
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.getIt<HomeworkBloc>()),
        BlocProvider(create: (_) => di.getIt<QuestionBloc>()),
      ],
      child: const HomeworkPage(),
    ),
    settings: settings,
  );
```

## 🎯 Best Practices

1. **Always use route constants** instead of hardcoded strings
2. **Use navigation extension methods** for consistent navigation
3. **Validate routes** before navigation when needed
4. **Handle route arguments** properly in destination pages
5. **Use stack management methods** for proper navigation flow

## 🚨 Error Handling

The routing system includes comprehensive error handling:
- Unknown routes show a user-friendly error page
- Route arguments are validated before use
- BLoC providers are properly initialized for each route

## 📚 Dependencies

- `flutter_bloc` - For BLoC provider management
- `injection_container` - For dependency injection
- Feature-specific BLoCs and pages

## 🔄 Migration from Old System

If migrating from the old static routes system:

1. Replace `routes: _buildAppRoutes()` with `onGenerateRoute: AppRouter.generateRoute`
2. Update navigation calls to use extension methods
3. Remove old route constants and use `AppRoutes.*` constants
4. Update any hardcoded route strings

## 🤝 Contributing

When adding new routes:

1. Add route constant to `AppRoutes` class
2. Add route case in `generateRoute` method
3. Add navigation method to `NavigationExtension`
4. Update `AppRouter` utility methods if needed
5. Update this documentation

---

**Note**: This routing system follows the same pattern used in the teacher app for consistency across the Smart School platform.

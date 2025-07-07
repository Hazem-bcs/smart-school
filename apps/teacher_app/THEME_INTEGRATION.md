# Theme Integration Guide - Teacher App

## Overview
The Teacher App now uses a centralized theme system integrated with the `core` package. This system provides:
- Dynamic theme switching (Light/Dark/System)
- Persistent theme preferences
- App-specific accent colors
- Reactive UI updates

## Architecture

### 1. ThemeManager (Core Package)
Located in `packages/core/lib/theme/theme_manager.dart`
- Manages theme state and persistence
- Provides theme switching methods
- Uses SharedPreferences for storage

### 2. TeacherTheme (Teacher App)
Located in `apps/teacher_app/lib/theme/teacher_theme.dart`
- Custom theme that inherits from core theme
- Teacher-specific colors and customizations
- Light and dark theme variants

### 3. ThemeBloc (Teacher App)
Located in `apps/teacher_app/lib/blocs/theme/theme_bloc.dart`
- Wraps ThemeManager for BLoC pattern integration
- Handles theme events and state management
- Provides reactive theme updates

### 4. App Integration
- `app.dart`: Configures MaterialApp with TeacherTheme
- `settings_page.dart`: Provides UI for theme switching

## Usage

### In Widgets
```dart
// Access theme state
BlocBuilder<ThemeBloc, ThemeState>(
  builder: (context, state) {
    if (state is ThemeLoaded) {
      return Text('Current theme: ${state.isDarkMode ? "Dark" : "Light"}');
    }
    return CircularProgressIndicator();
  },
)

// Trigger theme changes
context.read<ThemeBloc>().add(ToggleTheme());
context.read<ThemeBloc>().add(SetLightTheme());
context.read<ThemeBloc>().add(SetDarkTheme());
context.read<ThemeBloc>().add(SetSystemTheme());
```

### Theme Colors
```dart
// Access theme colors
Theme.of(context).colorScheme.primary;    // Teacher accent color
Theme.of(context).colorScheme.secondary;  // Secondary color
Theme.of(context).colorScheme.surface;    // Surface color
Theme.of(context).colorScheme.background; // Background color
```

### Text Styles
```dart
// Access theme text styles
Theme.of(context).textTheme.titleLarge;
Theme.of(context).textTheme.bodyMedium;
Theme.of(context).textTheme.labelSmall;
```

## Features

### 1. Theme Persistence
- Theme preferences are automatically saved
- App remembers user's theme choice across sessions
- System theme detection on first launch

### 2. Dynamic Switching
- Real-time theme switching without app restart
- Smooth transitions between themes
- Error handling with user feedback

### 3. App-Specific Colors
- Teacher primary color: Blue (#2196F3)
- Teacher secondary color: Darker Blue (#1976D2)
- Teacher accent color: Light Blue (#64B5F6)
- Teacher surface colors: Light (#F8FBFF) and Dark (#1A1A2E)
- Consistent branding across the app
- Easy customization for different app variants

## File Structure
```
apps/teacher_app/
├── lib/
│   ├── blocs/
│   │   └── theme/
│   │       └── theme_bloc.dart          # Theme state management
│   ├── theme/
│   │   ├── teacher_theme.dart           # Custom teacher theme
│   │   └── index.dart                   # Theme exports
│   ├── features/
│   │   └── settings/
│   │       └── presentation/
│   │           └── pages/
│   │               └── settings_page.dart # Theme toggle UI
│   └── app.dart                         # App configuration
└── assets/
    └── translations/
        ├── en.json                      # English translations
        └── ar.json                      # Arabic translations
```

## Configuration

### Adding ThemeBloc to New Screens
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc()..add(InitializeTheme()),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            // Your screen content
          );
        },
      ),
    );
  }
}
```

### Custom Theme Colors
To customize theme colors for the teacher app, modify the colors in `teacher_theme.dart`:
```dart
// Teacher-specific accent colors
static const Color teacherPrimary = Color(0xFF2196F3);      // Blue
static const Color teacherSecondary = Color(0xFF1976D2);    // Darker Blue
static const Color teacherAccent = Color(0xFF64B5F6);       // Light Blue
```

The theme automatically applies these colors to all UI components including:
- App bars
- Buttons
- Cards
- Input fields
- Switches
- Dividers

## Troubleshooting

### Common Issues
1. **Theme not updating**: Ensure ThemeBloc is properly initialized
2. **Colors not changing**: Check if widget uses Theme.of(context)
3. **Persistence not working**: Verify SharedPreferences permissions

### Debug Mode
Enable debug logging in ThemeManager:
```dart
ThemeManager(debugMode: true);
```

## Future Enhancements
- Custom theme presets
- Color scheme customization
- Animation transitions
- Accessibility theme support 
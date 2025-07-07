part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool isDarkMode;
  final bool generalNotifications;
  final bool classNotifications;
  final bool vibrationEnabled;
  final bool isLoggedOut;

  const SettingsState({
    this.isDarkMode = false,
    this.generalNotifications = true,
    this.classNotifications = true,
    this.vibrationEnabled = true,
    this.isLoggedOut = false,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? generalNotifications,
    bool? classNotifications,
    bool? vibrationEnabled,
    bool? isLoggedOut,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      generalNotifications: generalNotifications ?? this.generalNotifications,
      classNotifications: classNotifications ?? this.classNotifications,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
    );
  }

  @override
  List<Object?> get props => [
        isDarkMode,
        generalNotifications,
        classNotifications,
        vibrationEnabled,
        isLoggedOut,
      ];
}

class SettingsSaved extends SettingsState {
  const SettingsSaved() : super();
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
} 
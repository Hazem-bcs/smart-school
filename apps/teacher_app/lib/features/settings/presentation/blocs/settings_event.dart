part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class ToggleDarkMode extends SettingsEvent {}

class ToggleGeneralNotifications extends SettingsEvent {}

class ToggleClassNotifications extends SettingsEvent {}

class ToggleVibration extends SettingsEvent {}

class LogoutRequested extends SettingsEvent {} 
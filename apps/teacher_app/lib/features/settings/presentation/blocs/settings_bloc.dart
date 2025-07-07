import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<ToggleDarkMode>(_onToggleDarkMode);
    on<ToggleGeneralNotifications>(_onToggleGeneralNotifications);
    on<ToggleClassNotifications>(_onToggleClassNotifications);
    on<ToggleVibration>(_onToggleVibration);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onToggleDarkMode(
    ToggleDarkMode event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
    // TODO: حفظ الإعداد في التخزين المحلي
  }

  void _onToggleGeneralNotifications(
    ToggleGeneralNotifications event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(generalNotifications: !state.generalNotifications));
    // TODO: حفظ الإعداد في التخزين المحلي
  }

  void _onToggleClassNotifications(
    ToggleClassNotifications event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(classNotifications: !state.classNotifications));
    // TODO: حفظ الإعداد في التخزين المحلي
  }

  void _onToggleVibration(
    ToggleVibration event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(vibrationEnabled: !state.vibrationEnabled));
    // TODO: حفظ الإعداد في التخزين المحلي
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<SettingsState> emit,
  ) {
    // TODO: تنفيذ تسجيل الخروج
    emit(state.copyWith(isLoggedOut: true));
  }
}

class SettingsModel {
  final bool notifications;
  final bool darkMode;
  final String language;
  final bool autoSync;

  SettingsModel({
    required this.notifications,
    required this.darkMode,
    required this.language,
    required this.autoSync,
  });

  SettingsModel copyWith({
    bool? notifications,
    bool? darkMode,
    String? language,
    bool? autoSync,
  }) {
    return SettingsModel(
      notifications: notifications ?? this.notifications,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      autoSync: autoSync ?? this.autoSync,
    );
  }
} 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettings>(_onUpdateSettings);
  }

  void _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    
    try {
      // TODO: Load settings from local storage
      await Future.delayed(const Duration(seconds: 1));
      
      final settings = SettingsModel(
        notifications: true,
        darkMode: false,
        language: 'en',
        autoSync: true,
      );
      
      emit(SettingsLoaded(settings: settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  void _onUpdateSettings(
    UpdateSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      // TODO: Save settings to local storage
      emit(SettingsUpdated(settings: event.settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
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
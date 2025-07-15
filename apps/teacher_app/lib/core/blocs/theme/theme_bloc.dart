import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:core/theme/index.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class InitializeTheme extends ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class SetLightTheme extends ThemeEvent {}

class SetDarkTheme extends ThemeEvent {}

class SetSystemTheme extends ThemeEvent {}

// States
abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeLoading extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;
  final bool isDarkMode;
  final ThemeData currentTheme;

  const ThemeLoaded({
    required this.themeMode,
    required this.isDarkMode,
    required this.currentTheme,
  });

  @override
  List<Object?> get props => [themeMode, isDarkMode, currentTheme];

  ThemeLoaded copyWith({
    ThemeMode? themeMode,
    bool? isDarkMode,
    ThemeData? currentTheme,
  }) {
    return ThemeLoaded(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currentTheme: currentTheme ?? this.currentTheme,
    );
  }
}

class ThemeError extends ThemeState {
  final String message;

  const ThemeError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeManager _themeManager = ThemeManager();

  ThemeBloc() : super(ThemeInitial()) {
    on<InitializeTheme>(_onInitializeTheme);
    on<ToggleTheme>(_onToggleTheme);
    on<SetLightTheme>(_onSetLightTheme);
    on<SetDarkTheme>(_onSetDarkTheme);
    on<SetSystemTheme>(_onSetSystemTheme);

    // Listen to theme manager changes
    _themeManager.addListener(_onThemeManagerChanged);
  }

  Future<void> _onInitializeTheme(
    InitializeTheme event,
    Emitter<ThemeState> emit,
  ) async {
    emit(ThemeLoading());

    try {
      await _themeManager.initialize();
      
      emit(ThemeLoaded(
        themeMode: _themeManager.themeMode,
        isDarkMode: _themeManager.isDarkMode,
        currentTheme: _themeManager.getCurrentTheme(),
      ));
    } catch (e) {
      emit(ThemeError('Failed to initialize theme: $e'));
    }
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _themeManager.toggleTheme();
    } catch (e) {
      emit(ThemeError('Failed to toggle theme: $e'));
    }
  }

  Future<void> _onSetLightTheme(
    SetLightTheme event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _themeManager.setLightTheme();
    } catch (e) {
      emit(ThemeError('Failed to set light theme: $e'));
    }
  }

  Future<void> _onSetDarkTheme(
    SetDarkTheme event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _themeManager.setDarkTheme();
    } catch (e) {
      emit(ThemeError('Failed to set dark theme: $e'));
    }
  }

  Future<void> _onSetSystemTheme(
    SetSystemTheme event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _themeManager.setSystemTheme();
    } catch (e) {
      emit(ThemeError('Failed to set system theme: $e'));
    }
  }

  void _onThemeManagerChanged() {
    if (state is ThemeLoaded) {
      final currentState = state as ThemeLoaded;
      emit(currentState.copyWith(
        themeMode: _themeManager.themeMode,
        isDarkMode: _themeManager.isDarkMode,
        currentTheme: _themeManager.getCurrentTheme(),
      ));
    }
  }

  @override
  Future<void> close() {
    _themeManager.removeListener(_onThemeManagerChanged);
    return super.close();
  }
} 
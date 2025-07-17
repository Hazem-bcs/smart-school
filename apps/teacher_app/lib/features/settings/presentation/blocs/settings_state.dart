// part of 'settings_bloc.dart';
//
// class SettingsState extends Equatable {
//   final bool isDarkMode;
//   final bool generalNotifications;
//   final bool classNotifications;
//   final bool vibrationEnabled;
//   final bool isLoggedOut;
//
//   const SettingsState({
//     this.isDarkMode = false,
//     this.generalNotifications = true,
//     this.classNotifications = true,
//     this.vibrationEnabled = true,
//     this.isLoggedOut = false,
//   });
//
//   SettingsState copyWith({
//     bool? isDarkMode,
//     bool? generalNotifications,
//     bool? classNotifications,
//     bool? vibrationEnabled,
//     bool? isLoggedOut,
//   }) {
//     return SettingsState(
//       isDarkMode: isDarkMode ?? this.isDarkMode,
//       generalNotifications: generalNotifications ?? this.generalNotifications,
//       classNotifications: classNotifications ?? this.classNotifications,
//       vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
//       isLoggedOut: isLoggedOut ?? this.isLoggedOut,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//         isDarkMode,
//         generalNotifications,
//         classNotifications,
//         vibrationEnabled,
//         isLoggedOut,
//       ];
// }
//
// class SettingsSaved extends SettingsState {
//   const SettingsSaved() : super();
// }
//
// class SettingsError extends SettingsState {
//   final String message;
//
//   const SettingsError(this.message);
//
//   @override
//   List<Object?> get props => [message];
// }


// lib/features/settings/presentation/bloc/settings_state.dart

import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable { // تم تغيير الاسم هنا
  const SettingsState();

  @override
  List<Object> get props => [];
}

class LogoutInitial extends SettingsState {} // تم تغيير الامتداد هنا

class LogoutLoading extends SettingsState {} // تم تغيير الامتداد هنا

class LogoutSuccess extends SettingsState {} // تم تغيير الامتداد هنا

class LogoutFailure extends SettingsState { // تم تغيير الامتداد هنا
  final String message;

  const LogoutFailure({required this.message});

  @override
  List<Object> get props => [message];
}

// يمكنك إضافة حالات أخرى متعلقة بالإعدادات هنا في المستقبل
// class ThemeChanged extends SettingsState {
//   final ThemeMode currentMode;
//   const ThemeChanged(this.currentMode);
//   @override
//   List<Object> get props => [currentMode];
// }
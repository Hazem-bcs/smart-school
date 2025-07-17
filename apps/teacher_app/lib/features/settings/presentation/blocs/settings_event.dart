// part of 'settings_bloc.dart';
//
// abstract class SettingsEvent extends Equatable {
//   const SettingsEvent();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class ToggleDarkMode extends SettingsEvent {}
//
// class ToggleGeneralNotifications extends SettingsEvent {}
//
// class ToggleClassNotifications extends SettingsEvent {}
//
// class ToggleVibration extends SettingsEvent {}
//
// class LogoutRequested extends SettingsEvent {}



// lib/features/settings/presentation/bloc/settings_event.dart

import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable { // تم تغيير الاسم هنا
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LogoutButtonPressed extends SettingsEvent { // يبقى الاسم كما هو، لكنه الآن يمتد من SettingsEvent
  const LogoutButtonPressed();

  @override
  List<Object> get props => [];
}


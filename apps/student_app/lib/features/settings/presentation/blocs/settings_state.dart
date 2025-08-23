
import 'package:core/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable { // تم تغيير الاسم هنا
  const SettingsState();

  @override
  List<Object> get props => [];
}

// class LogoutInitial extends SettingsState {} // تم تغيير الامتداد هنا

// class LogoutLoading extends SettingsState {} // تم تغيير الامتداد هنا

// class LogoutSuccess extends SettingsState {} // تم تغيير الامتداد هنا

// class LogoutFailure extends SettingsState { // تم تغيير الامتداد هنا
//   final String message;

//   const LogoutFailure({required this.message});

//   @override
//   List<Object> get props => [message];
// }
class LogoutInitial extends SettingsState {}

class GetProfileLoading extends SettingsState {}

class GetProfileFailure extends SettingsState {
  final String message;

  const GetProfileFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class GetProfileSuccess extends SettingsState {
  final UserEntity user;

  const GetProfileSuccess({required this.user});

  @override
  List<Object> get props => [user];
}



// يمكنك إضافة حالات أخرى متعلقة بالإعدادات هنا في المستقبل
// class ThemeChanged extends SettingsState {
//   final ThemeMode currentMode;
//   const ThemeChanged(this.currentMode);
//   @override
//   List<Object> get props => [currentMode];
// }
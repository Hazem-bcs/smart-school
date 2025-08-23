
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

class GetProfileEvent extends SettingsEvent {
  const GetProfileEvent();
}

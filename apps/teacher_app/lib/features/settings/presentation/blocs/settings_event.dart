import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  
  @override
  List<Object?> get props => [];
}

class LogoutRequested extends SettingsEvent {
  final String userId;
  
  const LogoutRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}


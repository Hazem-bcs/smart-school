import 'package:equatable/equatable.dart';
import '../../domain/entities/logout_entity.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
  
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class LogoutLoading extends SettingsState {}

class LogoutSuccess extends SettingsState {
  final LogoutEntity logoutResult;
  
  const LogoutSuccess({required this.logoutResult});

  @override
  List<Object?> get props => [logoutResult];
}

class LogoutFailure extends SettingsState {
  final String message;
  
  const LogoutFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class CheckAuthenticationStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class LogoutEvent extends AuthEvent {}
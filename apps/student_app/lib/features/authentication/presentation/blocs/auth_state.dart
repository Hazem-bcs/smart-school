part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

// حالة جديدة لإظهار مؤشر التحميل
final class AuthChecking extends AuthState {}

final class Authenticated extends AuthState {
  // يمكنك تمرير بيانات المستخدم هنا إذا احتجت إليها في الواجهة
  // final UserEntity user;
  // Authenticated({required this.user});
}

final class Unauthenticated extends AuthState {}

final class LoginInitial extends AuthState {}

final class LoginSuccess extends AuthState {
}

final class LoginFailure extends AuthState {
  final String message;

  LoginFailure({required this.message});
}

final class LogoutSuccess extends AuthState {}

final class LogoutFailure extends AuthState {
  final String message;

  LogoutFailure({required this.message});
}
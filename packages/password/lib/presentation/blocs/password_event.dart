import 'package:equatable/equatable.dart';
import '../../domain/entities/password_change_request.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object?> get props => [];
}

class ChangePasswordRequested extends PasswordEvent {
  final PasswordChangeRequest request;

  const ChangePasswordRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class PasswordReset extends PasswordEvent {} 
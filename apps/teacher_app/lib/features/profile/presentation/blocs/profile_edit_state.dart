import 'package:equatable/equatable.dart';

abstract class ProfileEditState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileEditInitial extends ProfileEditState {}
class ProfileEditLoading extends ProfileEditState {}
class ProfileEditSuccess extends ProfileEditState {}
class ProfileEditError extends ProfileEditState {
  final String message;
  ProfileEditError(this.message);
  @override
  List<Object?> get props => [message];
} 
import 'package:equatable/equatable.dart';
import 'package:teacher_app/features/profile/domain/entities/profile.dart';

abstract class ProfileViewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileViewInitial extends ProfileViewState {}
class ProfileViewLoading extends ProfileViewState {}
class ProfileViewLoaded extends ProfileViewState {
  final Profile profile;
  ProfileViewLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}
class ProfileViewError extends ProfileViewState {
  final String message;
  ProfileViewError(this.message);
  @override
  List<Object?> get props => [message];
} 
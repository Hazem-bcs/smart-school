import 'package:equatable/equatable.dart';
import '../../domain/entities/profile.dart';

abstract class ProfileEditState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileEditInitial extends ProfileEditState {}
class ProfileEditLoading extends ProfileEditState {}
class ProfileEditLoaded extends ProfileEditState {
  final Profile profile;
  ProfileEditLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}
class ProfileEditSuccess extends ProfileEditState {
  final Profile updatedProfile;
  ProfileEditSuccess(this.updatedProfile);
  @override
  List<Object?> get props => [updatedProfile];
}
class ProfileEditError extends ProfileEditState {
  final String message;
  ProfileEditError(this.message);
  @override
  List<Object?> get props => [message];
} 
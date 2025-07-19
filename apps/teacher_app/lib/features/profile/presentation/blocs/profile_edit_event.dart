import 'package:equatable/equatable.dart';
import 'package:teacher_app/features/profile/domain/entities/profile.dart';

abstract class ProfileEditEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEditEvent {}

class SaveProfile extends ProfileEditEvent {
  final Profile profile;
  SaveProfile(this.profile);
  @override
  List<Object?> get props => [profile];
} 
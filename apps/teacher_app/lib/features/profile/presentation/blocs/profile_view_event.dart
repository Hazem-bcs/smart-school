import 'package:equatable/equatable.dart';
import '../../domain/entities/profile.dart';

abstract class ProfileViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileViewEvent {}

class UpdateProfileData extends ProfileViewEvent {
  final Profile profile;
  UpdateProfileData(this.profile);
  @override
  List<Object?> get props => [profile];
} 
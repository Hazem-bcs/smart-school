import 'package:equatable/equatable.dart';
import '../../domain/entities/profile.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final Profile profile;

  const UpdateProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

class EditProfile extends ProfileEvent {}

class NavigateToSocialMedia extends ProfileEvent {
  final String url;

  const NavigateToSocialMedia(this.url);

  @override
  List<Object?> get props => [url];
}

class ContactAction extends ProfileEvent {
  final String action;
  final String value;

  const ContactAction({required this.action, required this.value});

  @override
  List<Object?> get props => [action, value];
} 
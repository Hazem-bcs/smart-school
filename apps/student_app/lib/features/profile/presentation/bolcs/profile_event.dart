part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class GetProfileDataEvent extends ProfileEvent {}

class UpdateProfileDataEvent extends ProfileEvent {
  final String name;
  final String email;
  final String phone;
  final String address;
  final File? imageFile;

  UpdateProfileDataEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.imageFile,
  });
}
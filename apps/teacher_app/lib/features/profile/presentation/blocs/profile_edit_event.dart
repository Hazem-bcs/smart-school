import 'package:equatable/equatable.dart';
import 'package:teacher_app/features/profile/domain/entities/profile.dart';
import 'dart:io';

abstract class ProfileEditEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEditEvent {}

class SaveProfile extends ProfileEditEvent {
  final Profile profile;
  final File? imageFile;
  SaveProfile(this.profile, {this.imageFile});
  @override
  List<Object?> get props => [profile, imageFile?.path];
} 
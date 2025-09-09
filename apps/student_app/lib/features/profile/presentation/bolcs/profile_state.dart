part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class GetDataLoadingState extends ProfileState {}

  final class ProfileDataLoadedState extends ProfileState {
  final UserEntity userEntity;

  ProfileDataLoadedState({required this.userEntity});
}

  final class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState({required this.message});
}

final class UpdateProfileLoadingState extends ProfileState {}

final class UpdateProfileSuccessState extends ProfileState {
  final UserEntity userEntity;

  UpdateProfileSuccessState({required this.userEntity});
}

final class UpdateProfileErrorState extends ProfileState {
  final String message;

  UpdateProfileErrorState({required this.message});
}



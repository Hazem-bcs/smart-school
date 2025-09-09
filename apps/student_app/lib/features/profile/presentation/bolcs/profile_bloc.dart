import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/user_entity.dart';
import 'package:profile/domain/use_cases/get_user_profile_use_case.dart';
import 'package:flutter/material.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  ProfileBloc({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
  }) : super(ProfileInitial()) {
    on<GetProfileDataEvent>(_onGetProfileData);
    on<UpdateProfileDataEvent>(_onUpdateProfileData);
  }

  Future<void> _onGetProfileData(GetProfileDataEvent event ,Emitter<ProfileState> emit) async {
    emit(GetDataLoadingState());
    final result = await getUserProfileUseCase();
    result.fold(
      (failure) {
        emit(ProfileErrorState(message: failure.message));
      },
      (user) {
        emit(ProfileDataLoadedState(userEntity: user));
      }
    );
  }

  Future<void> _onUpdateProfileData(UpdateProfileDataEvent event, Emitter<ProfileState> emit) async {
    emit(UpdateProfileLoadingState());
    final result = await updateUserProfileUseCase(
      name: event.name,
      email: event.email,
      phone: event.phone,
      address: event.address,
      imageFile: event.imageFile,
    );
    result.fold(
      (failure) => emit(UpdateProfileErrorState(message: failure.message)),
      (user) {
        emit(UpdateProfileSuccessState(userEntity: user));
        emit(ProfileDataLoadedState(userEntity: user));
      },
    );
  }
}

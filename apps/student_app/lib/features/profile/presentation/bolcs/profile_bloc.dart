import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/user_entity.dart';
import 'package:profile/domain/use_cases/get_user_profile_use_case.dart';
import 'package:flutter/material.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  ProfileBloc({required this.getUserProfileUseCase}) : super(ProfileInitial()) {
    on<GetProfileDataEvent>(_onGetProfileData);
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
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:teacher_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'profile_edit_event.dart';
import 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final GetProfileUseCase getProfileUseCase;

  ProfileEditBloc({
    required this.updateProfileUseCase,
    required this.getProfileUseCase,
  }) : super(ProfileEditInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileEditLoading());
      final result = await getProfileUseCase();
      result.fold(
        (failure) => emit(ProfileEditError(failure.message)),
        (profile) => emit(ProfileEditLoaded(profile)),
      );
    });

    on<SaveProfile>((event, emit) async {
      emit(ProfileEditLoading());
      final result = await updateProfileUseCase(event.profile, imageFile: event.imageFile);
      result.fold(
        (failure) => emit(ProfileEditError(failure.message)),
        (updatedProfile) => emit(ProfileEditSuccess(updatedProfile)),
      );
    });
  }
} 
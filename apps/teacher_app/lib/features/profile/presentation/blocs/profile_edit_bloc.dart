import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'profile_edit_event.dart';
import 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileEditBloc({required this.updateProfileUseCase}) : super(ProfileEditInitial()) {
    on<SaveProfile>((event, emit) async {
      emit(ProfileEditLoading());
      final result = await updateProfileUseCase(event.profile);
      result.fold(
        (failure) => emit(ProfileEditError(failure)),
        (_) => emit(ProfileEditSuccess()),
      );
    });
  }
} 
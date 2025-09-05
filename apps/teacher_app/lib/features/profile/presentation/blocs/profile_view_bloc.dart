import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'profile_view_event.dart';
import 'profile_view_state.dart';

class ProfileViewBloc extends Bloc<ProfileViewEvent, ProfileViewState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileViewBloc({required this.getProfileUseCase}) : super(ProfileViewInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileViewLoading());
      final result = await getProfileUseCase();
      result.fold(
        (failure) => emit(ProfileViewError(failure.message)),
        (profile) => emit(ProfileViewLoaded(profile)),
      );
    });
  }
} 
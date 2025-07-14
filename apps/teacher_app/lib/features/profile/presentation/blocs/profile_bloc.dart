import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/entities/profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<EditProfile>(_onEditProfile);
    on<NavigateToSocialMedia>(_onNavigateToSocialMedia);
    on<ContactAction>(_onContactAction);
  }

  void _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    try {
      final result = await getProfileUseCase();
      
      result.fold(
        (error) => emit(ProfileError(error)),
        (profile) => emit(ProfileLoaded(profile)),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    try {
      final result = await updateProfileUseCase(event.profile);
      
      result.fold(
        (error) => emit(ProfileError(error)),
        (profile) => emit(ProfileUpdated(profile)),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onEditProfile(
    EditProfile event,
    Emitter<ProfileState> emit,
  ) {
    // TODO: Navigate to edit profile page
    print('Navigate to edit profile page');
  }

  void _onNavigateToSocialMedia(
    NavigateToSocialMedia event,
    Emitter<ProfileState> emit,
  ) {
    print('Navigating to ${event.url}');
    // TODO: Implement URL launcher
  }

  void _onContactAction(
    ContactAction event,
    Emitter<ProfileState> emit,
  ) {
    print('${event.action}: ${event.value}');
    // TODO: Implement contact actions (email, phone)
  }
} 
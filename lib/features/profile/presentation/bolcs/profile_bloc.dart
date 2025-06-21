import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_school/core/shared/domain/entites/user_entity.dart';
import 'package:smart_school/features/profile/domain/use_cases/get_user_profile_use_case.dart';

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

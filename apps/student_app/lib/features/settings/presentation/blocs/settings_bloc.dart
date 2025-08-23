import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/settings/domain/usecases/get_profile.dart';
import 'package:smart_school/features/settings/presentation/blocs/settings_event.dart';
import 'package:smart_school/features/settings/presentation/blocs/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetProfileUseCase getProfile;

  SettingsBloc({
    required this.getProfile,
  }) : super(LogoutInitial()) {
    on<GetProfileEvent>(_onGetProfileEvent);
  }

 
 void _onGetProfileEvent(
  GetProfileEvent event,
  Emitter<SettingsState> emit,
 ) async {
  emit(GetProfileLoading());
  final result = await getProfile();
  result.fold(
    (failure) {
      emit(GetProfileFailure(message: failure.message));
    },
    (user) {
      emit(GetProfileSuccess(user: user));
    },
  );
}
}

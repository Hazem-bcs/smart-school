import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/authentication/domain/auth_repository.dart'; // افترض أن Repository هنا

class OnboardingCubit extends Cubit<bool> {
  final AuthRepository _authRepository;

  // الحالة الأولية هي false (لم يرَ الـ onboarding)
  OnboardingCubit(this._authRepository) : super(false);

  // دالة للتحقق من الحالة عند بدء التطبيق
  Future<bool> checkOnboardingStatus() async {
    final hasSeen = await _authRepository.hasSeenOnboarding();
    emit(hasSeen);
    return hasSeen;
  }

  Future<void> setOnboardingViewed() async {
    await _authRepository.cacheOnboardingStatus();
    emit(true);
  }
}
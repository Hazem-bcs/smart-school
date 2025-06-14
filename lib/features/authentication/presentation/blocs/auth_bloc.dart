import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entites/user_entity.dart';
import '../../domain/usecases/cheakauthstatus_usecase.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LoginUseCase loginUseCase;

  AuthBloc({required this.checkAuthStatusUseCase,required this.loginUseCase}) : super(AuthInitial()) {
    on<CheckAuthenticationStatusEvent>(_onCheckAuthenticationStatus);
    on<LoginEvent>(_onLogin);
  }


  // this for splash screen
  Future<void> _onCheckAuthenticationStatus(CheckAuthenticationStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthChecking());

    final result = await checkAuthStatusUseCase();

    result.fold(
          (failure) {
        emit(Unauthenticated());
      },
          (userEntity) {
        emit(Authenticated());
      },
    );
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    // إصدار حالة التحميل أولاً
    emit(AuthChecking());

    // استدعاء الـ UseCase مع تمرير البيانات من الـ event
    final result = await loginUseCase(event.email, event.password);

    // التعامل مع النتيجة (نجاح أو فشل)
    result.fold(
          (failure) {
        // في حالة الفشل، نصدر حالة الفشل مع رسالة الخطأ
        emit(LoginFailure(message: failure.message));
      },
          (success) {
        emit(Authenticated());
      },
    );
  }
}

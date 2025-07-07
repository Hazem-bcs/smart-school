import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:auth/domain/usecases/cheakauthstatus_usecase.dart';
import 'package:auth/domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LoginUseCase loginUseCase;

  AuthBloc({
    required this.checkAuthStatusUseCase,
    required this.loginUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  void _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final result = await loginUseCase(event.email, event.password);
      
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(AuthAuthenticated()),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // TODO: Implement logout logic
      // await authRepository.logout();
      
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      print('🔍 Checking auth status...');
      
      // محاولة استخدام use case
      try {
        final result = await checkAuthStatusUseCase();
        
        result.fold(
          (failure) {
            print('❌ Auth check failed: ${failure.message}');
            // في حالة الفشل، نفترض أن المستخدم غير مسجل دخول
            emit(AuthUnauthenticated());
          },
          (isAuthenticated) {
            print('✅ Auth check result: $isAuthenticated');
            if (isAuthenticated) {
              print('🔐 User is authenticated, going to classes');
              emit(AuthAuthenticated());
            } else {
              print('🔓 User is not authenticated, going to login');
              emit(AuthUnauthenticated());
            }
          },
        );
      } catch (useCaseError) {
        print('💥 UseCase error: $useCaseError');
        // في حالة خطأ في use case، نفترض أن المستخدم غير مسجل دخول
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      print('💥 General auth check error: $e');
      // في حالة أي خطأ، نفترض أن المستخدم غير مسجل دخول
      emit(AuthUnauthenticated());
    }
  }
} 
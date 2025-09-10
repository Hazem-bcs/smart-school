import 'package:core/network/failures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/get_all_zoom_meetings_useCase.dart';
import 'zoom_meetings_event.dart';
import 'zoom_meetings_state.dart';

class ZoomMeetingsBloc extends Bloc<ZoomMeetingsEvent, ZoomMeetingsState> {
  final GetAllZoomMeetingsUseCase getAllZoomMeetingsUseCase;

  ZoomMeetingsBloc({required this.getAllZoomMeetingsUseCase})
    : super(const ZoomMeetingsInitial()) {
    on<GetZoomMeetings>(_onGetZoomMeetings);
  }

  Future<void> _onGetZoomMeetings(
    GetZoomMeetings event,
    Emitter<ZoomMeetingsState> emit,
  ) async {
    emit(const ZoomMeetingsLoading()); // Emit loading state

    final result = await getAllZoomMeetingsUseCase(); // Call the use case

    result.fold(
      (failure) {
        // If it's a Left (Failure), emit an error state
        emit(ZoomMeetingsError(message: _mapFailureToMessage(failure)));
      },
      (meetings) {
        // If it's a Right (List of ZoomMeeting), emit a loaded state
        emit(ZoomMeetingsLoaded(meetings: meetings));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ConnectionFailure:
        return "لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.";
      case ServerFailure:
        return "خطأ في الخادم. يرجى المحاولة لاحقاً.";
      case ValidationFailure:
        return (failure as ValidationFailure)
            .message; // Assuming message property exists
      case UnAuthenticated:
        return "المصادقة مطلوبة. يرجى تسجيل الدخول.";
      case CacheFailure:
        return "خطأ في الذاكرة المؤقتة. قد تكون البيانات قديمة.";
      default:
        return failure.message.isNotEmpty ? failure.message : "حدث خطأ غير متوقع.";
    }
  }
}

import 'dart:math';

import 'package:bloc/bloc.dart';

import '../../../../widgets/app_exports.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/use_cases/send_chat_message_use_case.dart';

part 'tutor_chat_event.dart';
part 'tutor_chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendChatMessageUseCase getGeminiResponse;

  ChatBloc({required this.getGeminiResponse}) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    // Add user message
    final messageEntity = MessageEntity(
      id: Random().nextInt(1000).toString(),
      author: ChatAuthor.user,
      text: event.message,
      createdAt: DateTime.now(),
    );
    emit(ChatSuccessState(messageEntity));

    // Get Gemini response
    final response = await getGeminiResponse(event.message);
    response.fold(
            (failure) => emit(ChatErrorState(failure.message)),
            (messageEntity) {
      emit(ChatSuccessState(messageEntity));
    });
  }
}
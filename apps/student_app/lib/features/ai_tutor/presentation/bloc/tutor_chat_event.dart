part of 'tutor_chat_bloc.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class SendMessageEvent extends ChatEvent {
  final String message;

  SendMessageEvent({required this.message});
}
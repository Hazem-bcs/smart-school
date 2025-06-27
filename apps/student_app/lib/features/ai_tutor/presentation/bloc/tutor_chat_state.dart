part of 'tutor_chat_bloc.dart';

@immutable
sealed class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatSuccessState extends ChatState {
  final MessageEntity messages;

  ChatSuccessState(this.messages);
}

class ChatErrorState extends ChatState {
  final String message;

  ChatErrorState(this.message);
}
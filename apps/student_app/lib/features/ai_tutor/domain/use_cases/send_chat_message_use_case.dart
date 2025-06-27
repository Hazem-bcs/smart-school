import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/repositories.dart';

class SendChatMessageUseCase {
  final AITutorRepository repository;

  SendChatMessageUseCase(this.repository);

  Future<Either<Failure, MessageEntity>> call(String message) {
    return repository.sendMessage(message);
  }
}
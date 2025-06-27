import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/chat_message_entity.dart';

abstract class AITutorRepository {
  Future<Either<Failure, MessageEntity>> sendMessage(String message);
}
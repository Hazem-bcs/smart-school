import 'package:core/network/failures.dart';
import 'package:core/network/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/chat_message_entity.dart';

import '../../domain/repositories/repositories.dart';
import '../datasources/ai_tutor_remote_datasource.dart';

class AITutorRepositoryImpl implements AITutorRepository {
  final AITutorRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AITutorRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(String message) async {
    if (await networkInfo.isConnected) {
      final aiResponseText = await remoteDataSource.sendMessageToApi(message);
      return aiResponseText.fold(
            (failure) => Left(failure),
            (text) {
          final aiMessageEntity = MessageEntity(
            id: const Uuid().v4(),
            text: text,
            author: ChatAuthor.ai,
            createdAt: DateTime.now(),
          );
          return Right(aiMessageEntity);
        },
      );
    } else {
      return Left(ConnectionFailure(message: 'connection failure'));
    }
  }
}
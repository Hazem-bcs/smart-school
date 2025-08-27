import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart'; // تأكد من استيراد هذه المكتبة

abstract class AITutorRemoteDataSource {
  Future<Either<Failure,String>> sendMessageToApi(String message);
}

class AITutorRemoteDataSourceImpl implements AITutorRemoteDataSource {
  final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');
  
  ChatSession? _chat;

  AITutorRemoteDataSourceImpl() {
    _startChatSession();
  }

  void _startChatSession() {
    print("Attempting to start chat session...");
    try {
      _chat = model.startChat(
        history: [
          Content.model([TextPart("أنت مدرس خصوصي ذكي...")]),
        ],
      );
      print("Chat session started successfully.");
    } catch (e) {
      print("Error starting chat session: $e");
    }
  }

  @override
  Future<Either<Failure,String>> sendMessageToApi(String message) async {
    print("Sending message to API: $message");

    if (_chat == null) {
      print("Chat session is null, attempting to restart.");
      _startChatSession(); 
      if (_chat == null) {
        print("Failed to restart chat session, cannot send message.");
        return Left(ServerFailure(message: "Chat session not initialized."));
      }
    }

    final prompt = [Content.text(message)];

    try {
      print("Calling _chat!.sendMessage()...");
      final response = await _chat!.sendMessage(prompt.first);
      
      // اطبع الاستجابة الكاملة لمعرفة ما إذا كانت تحتوي على أي معلومات غير متوقعة
      print("Full Gemini response object: $response");

      if (response.text != null) {
        print("Gemini response text: ${response.text}");
        return Right(response.text!);
      } else {
        print("Gemini response text is null. Potential issue.");
        return Left(ServerFailure(message: "Received empty or null response text from Gemini."));
      }
    } on FirebaseException catch (e) {
      // التعامل مع أخطاء Firebase بشكل خاص
      print("Firebase Exception when sending message: ${e.code} - ${e.message}");
      return Left(ServerFailure(message: "Firebase API error: ${e.message}"));
    } catch (e) {
      // التعامل مع أي أخطاء أخرى، بما في ذلك FormatException
      print("General Exception when sending message: $e");
      // هذا هو المكان الذي قد يظهر فيه FormatException
      if (e.toString().contains("FormatException")) {
          print("Caught FormatException! This means the data received was not in the expected format.");
          print("Please check your network connection and API configuration.");
      }
      return Left(ServerFailure(message: "Failed to get response from AI: $e")); 
    }
  }
}

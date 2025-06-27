import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

abstract class AITutorRemoteDataSource {
  Future<Either<Failure,String>> sendMessageToApi(String message);
}

class AITutorRemoteDataSourceImpl implements AITutorRemoteDataSource {
  final GenerativeModel _model;
  // سنجعل الشات قابلاً لإعادة الإنشاء إذا لزم الأمر
  ChatSession? _chat;

  AITutorRemoteDataSourceImpl()
  // 1. هنا ننشئ الموديل فقط مع مفتاح الـ API
      : _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    // تذكر: لا تكتب المفتاح هنا مباشرة في كود الإنتاج
    // استخدم متغيرات البيئة (environment variables)
    apiKey: 'AIzaSyBIjmZDqbNMHuMWO2zznIF2K3CG5F1SSrI',
  ) {
    // 2. نقوم ببدء الشات في جسم الكونستركتور
    _startChatSession();
  }

  void _startChatSession() {
    // 3. هذا هو المكان الصحيح لتمرير تعليمات النظام
    _chat = _model.startChat(
      history: [
        Content.model([TextPart("أنت مدرس خصوصي ذكي...")]), // رسالة النظام
      ],
    );
  }

  @override
  Future<Either<Failure,String>> sendMessageToApi(String message) async {
    // التأكد من أن الشات قد بدأ
    if (_chat == null) {
      _startChatSession();
    }

    try {
      final response = await _chat!.sendMessage(Content.text(message));
      final responseText = response.text;
      print(responseText);
      if (responseText == null) {
        return Left(ServerFailure(message: "Received an empty response from the AI."));
      }
      return Right(responseText);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
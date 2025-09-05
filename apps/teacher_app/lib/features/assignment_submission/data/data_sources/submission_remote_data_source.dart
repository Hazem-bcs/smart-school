import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/dio_client.dart';
import '../models/student_submission_model.dart';

abstract class SubmissionRemoteDataSource {
  Future<Either<Failure, List<StudentSubmissionModel>>> getStudentSubmissions();
  Future<Either<Failure, bool>> submitGrade(String submissionId, String grade, String feedback);
  Future<Either<Failure, bool>> markAssignmentAsGraded(String assignmentId);
}

class SubmissionRemoteDataSourceImpl implements SubmissionRemoteDataSource {
  final DioClient dioClient;

  SubmissionRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, List<StudentSubmissionModel>>> getStudentSubmissions() async {
    // ********************************************************
    // API وهمي (JSON ثابت) وفق الاستجابة الموحدة { data, message, status }
    const String mockJson = '''
    {
      "data": [
        {
          "id": "1",
          "studentName": "أوليفيا بينيت",
          "response": "يدور الموضوع المركزي للرواية حول البحث عن الهوية والانتماء في مجتمع يشهد تحولاً سريعاً.",
          "images": [
            "https://lh3.googleusercontent.com/aida-public/AB6AXuAaD4QFtFzumfJTmc8dZpX1E7ZZiiBy3S5RfyW2xHt_-VV6nri7AOQd9XFpgiwJMjjvV8lOzxpPcYHyERfdNYqSP4fkl2DpPj9wBy-QpMG1RR7TUkpqnG5MJ5Usnpg4lR6XKvB4BeLjex76QC8bq9YT6UhrSQCso448YWNJBbmmaJ9lU-1nFgAls9DruO3Z4jN8oyj3doObNi8yU2e-p9RmE92Dtm6CEs1450za3Ywi94F0FM9qI_LAp0lPzxY1p5QRi-mofQDfPY8_",
            "https://lh3.googleusercontent.com/aida-public/AB6AXuCoFqAIUnZ6twyCprcHwJmS_c3n3n1GVnwUzD1m1M10oqOLcUwq5dn9kaLLVobOLZKVafUk6baUC4a1KHKZCftsDjqByn1GKT3vgZjKVO-6lo9ygxv5zkXnfYh_8pt40hsqsnPL8JFtxcI6Ya4rfMhXswLMtVTYzk7VkPPFXOItOEx3hr8ewlHQ1Dbx8W2btlaZW4tyqmOCUxk6tw8k3Mf-LYI8bl64A_ii_tckmnZGR_NYrnumnYF6KtzGYsOIQrSLgQ9-I3NZCH20"
          ],
          "submittedAt": "2024-10-24T12:00:00.000",
          "isGraded": false
        },
        {
          "id": "2",
          "studentName": "إيما ويلسون",
          "response": "تستكشف الرواية موضوعات الهوية الثقافية والاندماج الاجتماعي من خلال منظور بطل شاب يواجه توقعات مجتمعية معقدة.",
          "images": [
            "https://lh3.googleusercontent.com/aida-public/AB6AXuAaD4QFtFzumfJTmc8dZpX1E7ZZiiBy3S5RfyW2xHt_-VV6nri7AOQd9XFpgiwJMjjvV8lOzxpPcYHyERfdNYqSP4fkl2DpPj9wBy-QpMG1RR7TUkpqnG5MJ5Usnpg4lR6XKvB4BeLjex76QC8bq9YT6UhrSQCso448YWNJBbmmaJ9lU-1nFgAls9DruO3Z4jN8oyj3doObNi8yU2e-p9RmE92Dtm6CEs1450za3Ywi94F0FM9qI_LAp0lPzxY1p5QRi-mofQDfPY8_"
          ],
          "submittedAt": "2024-10-25T10:00:00.000",
          "isGraded": true,
          "grade": "85",
          "feedback": "تحليل ممتاز للموضوعات الثقافية وإجابة منظمة."
        },
        {
          "id": "3",
          "studentName": "خميس الرويلي",
          "response": "يقدم النص استكشافاً مقنعاً لتشكّل الهوية في المجتمعات متعددة الثقافات.",
          "images": [],
          "submittedAt": "2024-10-25T18:00:00.000",
          "isGraded": false
        }
      ],
      "message": "تم جلب بيانات التسليمات بنجاح",
      "status": 200
    }
    ''';
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      final Map<String, dynamic> decoded = jsonDecode(mockJson) as Map<String, dynamic>;
      final int status = decoded['status'] is int ? decoded['status'] as int : 500;
      if (status != 200) {
        final String message = decoded['message']?.toString() ?? 'حدث خطأ غير متوقع';
        return Left(ServerFailure(message: message, statusCode: status));
      }
      final List<dynamic> data = List<dynamic>.from(decoded['data'] as List<dynamic>);
      final List<StudentSubmissionModel> items = data
          .map((e) => StudentSubmissionModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      return Right(items);
    } catch (_) {
      return const Left(UnknownFailure(message: 'خطأ في تحليل البيانات'));
    }
    // ********************************************************

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // final result = await dioClient.get('/assignments/submissions');
    // return result.fold(
    //   (failure) => Left(failure),
    //   (response) {
    //     final Map<String, dynamic>? body = response.data as Map<String, dynamic>?;
    //     final int status = body?['status'] is int ? body!['status'] as int : 500;
    //     if (status != 200) {
    //       final String message = body?['message']?.toString() ?? 'حدث خطأ غير متوقع';
    //       return Left(ServerFailure(message: message, statusCode: status));
    //     }
    //     final List<dynamic> raw = List<dynamic>.from(body?['data'] as List<dynamic>);
    //     final items = raw
    //         .map((e) => StudentSubmissionModel.fromJson(Map<String, dynamic>.from(e as Map)))
    //         .toList();
    //     return Right(items);
    //   },
    // );
    */
  }

  @override
  Future<Either<Failure, bool>> submitGrade(String submissionId, String grade, String feedback) async {
    // ********************************************************
    // API وهمي
    const String mockJson = '{"data": true, "message": "تم حفظ التقييم بنجاح", "status": 200}';
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final Map<String, dynamic> decoded = jsonDecode(mockJson) as Map<String, dynamic>;
      final int status = decoded['status'] is int ? decoded['status'] as int : 500;
      if (status != 200) {
        return Left(ServerFailure(message: decoded['message']?.toString() ?? 'فشل حفظ التقييم', statusCode: status));
      }
      return const Right(true);
    } catch (_) {
      return const Left(UnknownFailure(message: 'خطأ في تحليل البيانات'));
    }
    // ********************************************************

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // final result = await dioClient.post(
    //   '/assignments/submissions/grade',
    //   data: { 'submissionId': submissionId, 'grade': grade, 'feedback': feedback },
    // );
    // return result.fold(
    //   (failure) => Left(failure),
    //   (response) {
    //     final body = response.data as Map<String, dynamic>?;
    //     final int status = body?['status'] is int ? body!['status'] as int : 500;
    //     if (status != 200) {
    //       return Left(ServerFailure(message: body?['message']?.toString() ?? 'فشل حفظ التقييم', statusCode: status));
    //     }
    //     return const Right(true);
    //   },
    // );
    */
  }

  @override
  Future<Either<Failure, bool>> markAssignmentAsGraded(String assignmentId) async {
    // ********************************************************
    // API وهمي
    const String mockJson = '{"data": true, "message": "تم وضع الواجب كمصحح", "status": 200}';
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final Map<String, dynamic> decoded = jsonDecode(mockJson) as Map<String, dynamic>;
      final int status = decoded['status'] is int ? decoded['status'] as int : 500;
      if (status != 200) {
        return Left(ServerFailure(message: decoded['message']?.toString() ?? 'فشل تنفيذ العملية', statusCode: status));
      }
      return const Right(true);
    } catch (_) {
      return const Left(UnknownFailure(message: 'خطأ في تحليل البيانات'));
    }
    // ********************************************************

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // final result = await dioClient.post(
    //   '/assignments/mark-graded',
    //   data: { 'assignmentId': assignmentId },
    // );
    // return result.fold(
    //   (failure) => Left(failure),
    //   (response) {
    //     final body = response.data as Map<String, dynamic>?;
    //     final int status = body?['status'] is int ? body!['status'] as int : 500;
    //     if (status != 200) {
    //       return Left(ServerFailure(message: body?['message']?.toString() ?? 'فشل تنفيذ العملية', statusCode: status));
    //     }
    //     return const Right(true);
    //   },
    // );
    */
  }
}
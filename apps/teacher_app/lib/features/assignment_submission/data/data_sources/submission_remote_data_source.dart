import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../models/student_submission_model.dart';

class SubmissionRemoteDataSource {
  Future<Either<Failure, List<StudentSubmissionModel>>> getStudentSubmissions() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // محاكاة خطأ عشوائي بنسبة 20%
    if (DateTime.now().millisecondsSinceEpoch % 5 == 0) {
      return Left(ServerFailure(message: 'خطأ في الاتصال بالخادم'));
    }
    try {
      final Map<String, dynamic> response = {
        'success': true,
        'statuscode': 200,
        'data': [
          {
            'id': '1',
            'studentName': 'Olivia Bennett',
            'response': 'The central theme of the novel revolves around the quest for identity and belonging in a society undergoing rapid transformation.',
            'images': [
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAaD4QFtFzumfJTmc8dZpX1E7ZZiiBy3S5RfyW2xHt_-VV6nri7AOQd9XFpgiwJMjjvV8lOzxpPcYHyERfdNYqSP4fkl2DpPj9wBy-QpMG1RR7TUkpqnG5MJ5Usnpg4lR6XKvB4BeLjex76QC8bq9YT6UhrSQCso448YWNJBbmmaJ9lU-1nFgAls9DruO3Z4jN8oyj3doObNi8yU2e-p9RmE92Dtm6CEs1450za3Ywi94F0FM9qI_LAp0lPzxY1p5QRi-mofQDfPY8_',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCoFqAIUnZ6twyCprcHwJmS_c3n3n1GVnwUzD1m1M10oqOLcUwq5dn9kaLLVobOLZKVafUk6baUC4a1KHKZCftsDjqByn1GKT3vgZjKVO-6lo9ygxv5zkXnfYh_8pt40hsqsnPL8JFtxcI6Ya4rfMhXswLMtVTYzk7VkPPFXOItOEx3hr8ewlHQ1Dbx8W2btlaZW4tyqmOCUxk6tw8k3Mf-LYI8bl64A_ii_tckmnZGR_NYrnumnYF6KtzGYsOIQrSLgQ9-I3NZCH20'
            ],
            'submittedAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
            'isGraded': false,
          },
          {
            'id': '2',
            'studentName': 'Emma Wilson',
            'response': 'The novel explores themes of cultural identity and social integration through the lens of a young protagonist navigating complex societal expectations.',
            'images': [
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAaD4QFtFzumfJTmc8dZpX1E7ZZiiBy3S5RfyW2xHt_-VV6nri7AOQd9XFpgiwJMjjvV8lOzxpPcYHyERfdNYqSP4fkl2DpPj9wBy-QpMG1RR7TUkpqnG5MJ5Usnpg4lR6XKvB4BeLjex76QC8bq9YT6UhrSQCso448YWNJBbmmaJ9lU-1nFgAls9DruO3Z4jN8oyj3doObNi8yU2e-p9RmE92Dtm6CEs1450za3Ywi94F0FM9qI_LAp0lPzxY1p5QRi-mofQDfPY8_'
            ],
            'submittedAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
            'isGraded': true,
            'grade': '85',
            'feedback': 'Excellent analysis of cultural themes. Well-structured response.',
          },
          {
            'id': '3',
            'studentName': 'James Rodriguez',
            'response': 'The story presents a compelling exploration of identity formation in multicultural societies.',
            'images': [],
            'submittedAt': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
            'isGraded': false,
          },
        ],
        'message': 'تم جلب بيانات التسليمات بنجاح',
      };

      if (response['success'] == true && response['statuscode'] == 200) {
        final students = (response['data'] as List)
            .map((json) => StudentSubmissionModel.fromJson(json))
            .toList();
        return Right(students);
      } else {
        return Left(ServerFailure(message: response['message'] ?? 'خطأ غير معروف'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'خطأ في تحليل البيانات'));
    }
  }

  Future<Either<Failure, bool>> submitGrade(String submissionId, String grade, String feedback) async {

    // محاكاة خطأ عشوائي بنسبة 20%
    if (DateTime.now().millisecondsSinceEpoch % 5 == 0) {
      return Left(ServerFailure(message: 'خطأ في الاتصال بالخادم'));
    }
    // رد وهمي للنجاح
    return const Right(true);
  }

  Future<Either<Failure, bool>> markAssignmentAsGraded(String assignmentId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // محاكاة خطأ عشوائي بنسبة 20%
    if (DateTime.now().millisecondsSinceEpoch % 1 == 0) {
      return Left(ServerFailure(message: 'خطأ في الاتصال بالخادم'));
    }
    // رد وهمي للنجاح
    return const Right(true);
  }
} 
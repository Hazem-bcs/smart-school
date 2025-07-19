import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../../models/assignment_model.dart';
import '../../../domain/entities/assignment.dart';

abstract class AssignmentRemoteDataSource {
  Future<Either<Failure, List<AssignmentModel>>> getAssignments({String? searchQuery, AssignmentStatus? filter});
}

class AssignmentRemoteDataSourceImpl implements AssignmentRemoteDataSource {
  // بيانات وهمية مؤقتة
  final List<Map<String, dynamic>> _allAssignmentsJson = [
    {
      "id": "1",
      "title": "Math Quiz 1",
      "subtitle": "Due: Oct 26 · 25/25 submitted",
      "isCompleted": true,
      "dueDate": "2024-10-26T00:00:00.000",
      "submittedCount": 25,
      "totalCount": 25,
      "status": "graded",
    },
    {
      "id": "2",
      "title": "Science Project",
      "subtitle": "Due: Oct 27 · 20/25 submitted",
      "isCompleted": false,
      "dueDate": "2024-10-27T00:00:00.000",
      "submittedCount": 20,
      "totalCount": 25,
      "status": "ungraded",
    },
    {
      "id": "3",
      "title": "English Essay",
      "subtitle": "Due: Oct 28 · 25/25 submitted",
      "isCompleted": true,
      "dueDate": "2024-10-28T00:00:00.000",
      "submittedCount": 25,
      "totalCount": 25,
      "status": "graded",
    },
    {
      "id": "4",
      "title": "History Report",
      "subtitle": "Due: Oct 29 · 22/25 submitted",
      "isCompleted": false,
      "dueDate": "2024-10-29T00:00:00.000",
      "submittedCount": 22,
      "totalCount": 25,
      "status": "ungraded",
    },
    {
      "id": "5",
      "title": "Art Portfolio",
      "subtitle": "Due: Oct 30 · 25/25 submitted",
      "isCompleted": true,
      "dueDate": "2024-10-30T00:00:00.000",
      "submittedCount": 25,
      "totalCount": 25,
      "status": "graded",
    },
  ];

  @override
  Future<Either<Failure, List<AssignmentModel>>> getAssignments({String? searchQuery, AssignmentStatus? filter}) async {
    // ملاحظة: الكود التالي وهمي فقط، عند الربط مع الـ backend استبدله بطلب فعلي
    await Future.delayed(const Duration(milliseconds: 800));
    
    // محاكاة خطأ عشوائي (10% احتمال حدوث خطأ)
    if (DateTime.now().millisecondsSinceEpoch % 10 == 0) {
      final Map<String, dynamic> errorResponse = {
        'success': false,
        'statuscode': 500,
        'message': 'خطأ في الخادم - يرجى المحاولة مرة أخرى',
      };
      return Left(ServerFailure(message: errorResponse['message']));
    }
    
    // محاكاة استجابة من السيرفر
    final Map<String, dynamic> response = {
      'success': true,
      'statuscode': 200,
      'data': _allAssignmentsJson,
      'message': 'تم جلب الواجبات بنجاح',
    };

    if (response['success'] == true && response['statuscode'] == 200) {
        List<AssignmentModel> filtered = (response['data'] as List)
            .map((json) => AssignmentModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        // تطبيق البحث
        if (searchQuery != null && searchQuery.isNotEmpty) {
          filtered = filtered.where((a) =>
            a.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            a.subtitle.toLowerCase().contains(searchQuery.toLowerCase())
          ).toList();
        }
        
        // تطبيق الفلتر
        if (filter != null && filter != AssignmentStatus.all) {
          filtered = filtered.where((a) => a.status == filter).toList();
        }
        
        return Right(filtered);
    } else {
      return Left(ServerFailure(message: response['message'] ?? 'خطأ في جلب الواجبات'));
    }
  }
}

// Assignment Remote Data Source Implementation:
// 1. Mock Data: Uses JSON format to simulate real backend responses
// 2. Error Handling: Returns Either<Failure, Data> for proper error management
// 3. Response Simulation: Mimics real backend responses with success/error structure
// 4. Error Simulation: Random errors to test error handling (10% for get)
// 5. Search & Filter: Local filtering and searching functionality
// 6. Type Safety: Proper JSON parsing with null safety and error handling
// 7. Consistent Pattern: Follows same pattern as ProfileRemoteDataSource
// 8. Clean Implementation: Only includes necessary getAssignments functionality
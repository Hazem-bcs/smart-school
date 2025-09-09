import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/constant.dart';
import '../models/assignment_model.dart';

abstract class AssignmentRemoteDataSource {
  Future<Either<Failure, List<AssignmentModel>>> getAssignments(String classId);
  Future<Either<Failure, Unit>> submitAssignment({
    required String assignmentId,
    required String studentId,
    required String answerText,
    File? imageFile,
  });
}

class AssignmentRemoteDataSourceImpl implements AssignmentRemoteDataSource {
  final DioClient? dioClient;
  AssignmentRemoteDataSourceImpl({this.dioClient});
  static const String _assetPath = 'assets/mock/assignments.json';

  @override
  Future<Either<Failure, List<AssignmentModel>>> getAssignments(String classId) async {
    try {
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(milliseconds: 600));

      // محاكاة فشل عشوائي في الخادم
      if (Random().nextDouble() < 0.1) {
        return Left(ServerFailure(message: 'فشل في جلب البيانات. حاول مرة أخرى لاحقاً.'));
      }

      final String jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      final List<AssignmentModel> all = jsonList
          .map((e) => AssignmentModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // تصفية حسب الصف إن لزم
      final List<AssignmentModel> filtered = classId.isEmpty
          ? all
          : all.where((a) => a.classId == classId).toList();

      return Right(filtered);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitAssignment({
    required String assignmentId,
    required String studentId,
    required String answerText,
    File? imageFile,
  }) async {
    // إذا لم يتم حقن DioClient بعد، نحاكي الاستجابة بنجاح
    if (dioClient == null) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (Random().nextDouble() < 0.1) {
        return Left(ServerFailure(message: 'تعذر إرسال المهمة مؤقتاً'));
      }
      return const Right(unit);
    }

    try {
      final Map<String, dynamic> formMap = {
        'assignment_id': assignmentId,
        'student_id': studentId,
        'answer_text': answerText,
      };

      if (imageFile != null) {
        formMap['attachment'] = await MultipartFile.fromFile(
          imageFile.path,
        );
      }

      final formData = FormData.fromMap(formMap);
      final result = await dioClient!.post(
        Constants.submitAssignmentEndpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return result.fold(
        (failure) => Left(failure),
        (_) => const Right(unit),
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}

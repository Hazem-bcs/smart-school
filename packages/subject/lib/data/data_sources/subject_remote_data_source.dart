import 'package:core/data/models/subject_model.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

abstract class SubjectRemoteDataSource {
  Future<Either<Failure, SubjectModel>> getSubject(int id);

  Future<Either<Failure, List<SubjectModel>>> getSubjectList(int id);
}

class SubjectRemoteDataSourceImpl implements SubjectRemoteDataSource {
  final DioClient dioClient;

  SubjectRemoteDataSourceImpl({required this.dioClient});


  SubjectModel _getDummySubjectById(int id) {
    final List<SubjectModel> allSubjects = [
      SubjectModel(
        id: 1,
        name: 'رياضيات',
        image:
            'https://cbx-prod.b-cdn.net/COLOURBOX60175808.jpg?width=800&height=800&quality=70',
        teachers: ['أ. أحمد محمود', 'د. سارة فؤاد'],
        notes: ['دروس أسبوعياً 5', 'يجب إحضار الآلة الحاسبة العلمية'],
      ),
      SubjectModel(
        id: 2,
        name: 'علوم',
        image:
            'https://cbx-prod.b-cdn.net/COLOURBOX60175808.jpg?width=800&height=800&quality=70',
        teachers: ['د. سارة فؤاد'],
        notes: ['مختبر عملي كل أسبوعين'],
      ),
      SubjectModel(
        id: 3,
        name: 'عربي',
        image:
            'https://cbx-prod.b-cdn.net/COLOURBOX60175808.jpg?width=800&height=800&quality=70',
        teachers: ['أ. محمد علي'],
        notes: ['قراءات إضافية مطلوبة'],
      ),
      SubjectModel(
        id: 4,
        name: 'جغرافيا',
        image:
            'https://cbx-prod.b-cdn.net/COLOURBOX60175808.jpg?width=800&height=800&quality=70',
        teachers: ['أ. ليلى حسن'],
        notes: ['مشروع بحث في نهاية الفصل'],
      ),
    ];
    // إيجاد المادة باستخدام المعرف أو إرجاع قيمة افتراضية في حالة عدم العثور عليها
    return allSubjects.firstWhere(
      (subject) => subject.id == id,
      orElse: () => allSubjects.first,
    );
  }

  @override
  Future<Either<Failure, SubjectModel>> getSubject(int id) async {
    // try {
    //   final response = await dioClient.post(
    //     Constants.getSubjectEndpoint,
    //     data: {'id': id},
    //   );
    //   return Right(SubjectModel.fromJson(response.data));
    // } on DioException catch (e) {
    //   return Left(handleDioException(e));
    // } catch (e) {
    //   return Left(UnknownFailure(message: 'Unknown error occurred'));
    // }
    return Right(_getDummySubjectById(id));
  }

  @override
  Future<Either<Failure, List<SubjectModel>>> getSubjectList(int id) async {
    // try {
    //   final response = await dioClient.post(
    //     Constants.getSubjectListEndpoint,
    //     data: {'id': id},
    //   );
    //   return Right(response.data);
    // } on DioException catch (e) {
    //   return Left(handleDioException(e));
    // } catch (e) {
    //   return Left(UnknownFailure(message: 'Unknown error occurred'));
    // }
    return Right([
      SubjectModel(
        id: 1,
        name: 'رياضيات',
        image:
            'https://cbx-prod.b-cdn.net/COLOURBOX60175808.jpg?width=800&height=800&quality=70',
        teachers: ['أ. أحمد محمود'],
        notes: ['دروس أسبوعياً 5'],
      ),
      SubjectModel(
        id: 2,
        name: 'علوم',
        image:
            'https://cbx-prod.b-cdn.net/COLOURBOX60175808.jpg?width=800&height=800&quality=70',
        teachers: ['د. سارة فؤاد'],
        notes: ['مختبر عملي كل أسبوعين'],
      ),
      SubjectModel(
        id: 3,
        name: 'عربي',
        image:
            'https://cbx-prod.b-cdn.net/COLOURBOX60175808.jpg?width=800&height=800&quality=70',
        teachers: ['أ. محمد علي'],
        notes: ['قراءات إضافية مطلوبة'],
      ),
      SubjectModel(
        id: 4,
        name: 'جغرافيا',
        image:
            'https://cbx-prod.b-cdn.net/COLOURBOX60175808.jpg?width=800&height=800&quality=70',
        teachers: ['أ. ليلى حسن'],
        notes: ['مشروع بحث في نهاية الفصل'],
      ),
    ]);
  }
}

# Teacher Feature Package

هذا الحزمة تحتوي على ميزة المعلمين في تطبيق Smart School.

## 📁 هيكل الملفات

```
lib/
├── data/
│   ├── constants/
│   │   └── api_constants.dart          # ثوابت API
│   ├── data_sources/
│   │   └── teacher_remote_data_source.dart  # مصدر البيانات البعيد
│   └── models/
│       └── teacher_model.dart          # نموذج المعلم
├── domain/
│   └── teacher_entity.dart             # كيان المعلم
└── README.md
```

## 🔄 التحديثات الجديدة

### نموذج المعلم المحدث (TeacherModel)

تم تحديث نموذج المعلم ليتوافق مع البيانات المرجعة من الـ backend:

```dart
class TeacherModel {
  final int id;
  final String name;
  final String email;
  final String? password;
  final int specializationId;
  final int genderId;
  final String joiningDate;
  final String address;
  final int isLogged;
  final String? createdAt;
  final String? updatedAt;
  final String image;
  final String description;
  final String phone;
  final List<SubjectModel> subjectList;
}
```

### البيانات المرجعة من الـ Backend

```json
{
    "data": [
        {
            "id": 1,
            "email": "osama@gmail.com",
            "password": "$2y$12$9KAffbjWm8LoNHLKCFVUDuULXVCEkfbNk1fPh42VFvunQkstY0GfS",
            "name": "osama mohammad",
            "Specialization_id": 2,
            "Gender_id": 1,
            "Joining_Date": "2025-06-03",
            "Address": "Aleppo-Syria",
            "is_logged": 0,
            "created_at": null,
            "updated_at": "2025-06-26T06:51:19.000000Z"
        }
    ],
    "message": "Ok",
    "status": 200
}
```

## 🚀 كيفية الاستخدام

### 1. تفعيل الاتصال بالـ Backend

لتشغيل الاتصال الفعلي بالـ backend، قم بإلغاء التعليق عن الكود في `teacher_remote_data_source.dart`:

```dart
// في دالة getTeacherList
final response = await dioClient.get(
  TeacherApiConstants.getTeachersList,
  queryParameters: {'student_id': studentId},
);

if (response.data['status'] == 200) {
  final List<dynamic> teachersData = response.data['data'];
  final teachers = teachersData
      .map((teacherJson) => TeacherModel.fromJson(teacherJson))
      .toList();
  return Right(teachers);
} else {
  return Left(ServerFailure(message: response.data['message'] ?? 'Unknown error'));
}
```

### 2. إضافة البيانات المفقودة

إذا كانت البيانات المرجعة من الـ backend لا تحتوي على بعض الحقول، سيتم استخدام القيم الافتراضية:

- `image`: سيتم استخدام `assets/images/user.png`
- `description`: سيتم استخدام `'No description available'`
- `phone`: سيتم استخدام `'No phone available'`
- `subjects`: سيتم استخدام قائمة فارغة

## 🔧 التخصيص

### إضافة حقول جديدة

لإضافة حقول جديدة إلى نموذج المعلم:

1. أضف الحقل إلى `TeacherModel`
2. أضف الحقل إلى `TeacherEntity`
3. حدث دالة `fromJson` في `TeacherModel`
4. حدث دالة `toEntity` في `TeacherModel`

### تغيير API Endpoints

لتغيير نقاط النهاية، قم بتحديث `api_constants.dart`:

```dart
class TeacherApiConstants {
  static const String baseUrl = '/api/v1';  // تغيير الإصدار
  static const String getTeachersList = '$baseUrl/teachers';
  static const String getTeacherById = '$baseUrl/teachers';
}
```

## 🧪 الاختبار

النظام يدعم البيانات الوهمية للاختبار. يمكنك استخدام البيانات الوهمية المحددة في `_dummyTeachers` للاختبار المحلي.

## 📝 ملاحظات مهمة

1. **معالجة الأخطاء**: يتم استخدام `Either<Failure, Data>` لمعالجة الأخطاء
2. **التحقق من الصحة**: يتم التحقق من صحة البيانات المرجعة من الـ backend
3. **القيم الافتراضية**: يتم استخدام قيم افتراضية للحقول المفقودة
4. **التوافق**: النظام متوافق مع Clean Architecture

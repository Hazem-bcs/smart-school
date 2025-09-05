# Home Feature - Clean Architecture with dartz and Mock/Real API Toggle

هذا القسم يوضح كيف بنيّنا ميزة الصفحة الرئيسية وفق قواعد المشروع:

- Layers: data → domain → presentation
- Error handling: Either<Failure, T> من dartz
- Network: DioClient من الحزمة core
- JSON Response Wrapper: { "data": ..., "message": "...", "status": 200 }

## Data Layer

- HomeRemoteDataSource:
  - يرجع Either<Failure, List<Model>> لكل طرق الجلب، و Either<Failure, Unit> لعمليات الكتابة.
  - حالياً يستخدم JSON وهمي ضمن سطرين نجوم كمصدر مؤقت. عند جاهزية الـ back-end:
    1) احذف الـ JSON الوهمي بين سطرَي النجوم.
    2) فك التعليق عن كتلة استدعاء DioClient.

- التنسيق العام للـ JSON:
```
{
  "data": [ /* أو {"items": [...]} */ ],
  "message": "تم الجلب بنجاح",
  "status": 200
}
```

- عند status != 200 يتم إرجاع Failure مناسب.

## Domain Layer

- HomeRepository: يرجع Either<Failure, Entity> بدلاً من الاستثناءات.
- UseCases: مجرد تمرير للنداء إلى المستودع بنفس صيغة Either.

## Presentation Layer

- HomeBloc: يتعامل مع Either ويحوّلها إلى حالات:
  - HomeLoading
  - HomeLoaded(classes, notifications, assignments= [])
  - HomeError(message)
- UI:
  - BlocProvider(HomeBloc) في `home_page.dart` مع `LoadHomeData`.
  - Widgets للحالات: `HomeLoadingWidget`, `HomeErrorWidget`, `HomeEmptyWidget`.
  - عند الجاهزية يتم عرض البيانات الفعلية.

## تبديل الوهمي إلى API حقيقي

في `data/data_sources/home_remote_data_source.dart` لكل دالة:
- احذف قسم JSON الوهمي بين:
  // ********************************************************
  // ...
  // ********************************************************
- فك تعليق كتلة DioClient، واضبط:
  - baseUrl
  - getToken إن لزم
  - المسارات: /classes, /assignments, /notifications

## Dependency Injection

تم تسجيل:
- DataSource → Repository → UseCases → Bloc في `injection_container.dart`.

## حالات الخطأ والفراغ
- الخطأ: يعرض `HomeErrorWidget` برسالة عربية وزر إعادة المحاولة.
- الفراغ: يعرض `HomeEmptyWidget`.

هذا النمط موحّد وسهل القراءة وقابل للتوسعة.

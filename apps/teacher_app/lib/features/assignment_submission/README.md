# 📚 ميزة تصحيح تسليمات الواجبات (Assignment Submission)

## نظرة عامة

هذه الميزة تتيح للمعلم استعراض تسليمات الطلاب لواجب معين، تصحيحها، وإعطاء درجة وتعليق لكل طالب، مع إمكانية التنقل بين التسليمات وجعل الواجب منتهي بعد التصحيح.

الميزة مبنية بالكامل وفق **Clean Architecture** واتباع قواعد المشروع (feature-based, separation of concerns, error handling, mock data).

---

## ⚙️ الهيكلية

```
assignment_submission/
├── data/
│   ├── data_sources/
│   │   └── submission_remote_data_source.dart
│   ├── models/
│   │   └── student_submission_model.dart
│   └── repositories/
│       └── submission_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── student_submission.dart
│   ├── repositories/
│   │   └── submission_repository.dart
│   └── usecases/
│       ├── get_student_submissions_usecase.dart
│       └── submit_grade_usecase.dart
└── presentation/
    ├── blocs/
    │   ├── submission_bloc.dart
    │   ├── submission_event.dart
    │   └── submission_state.dart
    └── ui/
        └── ... (صفحات وودجتس العرض)
```

---

## 🧩 كيف تعمل الميزة؟

1. **جلب التسليمات:**
   - عند فتح صفحة تصحيح الواجب، يتم استدعاء usecase `GetStudentSubmissionsUseCase` عبر الـ Bloc.
   - يقوم الـ Repository بجلب البيانات من Data Source (حاليًا بيانات وهمية بنمط استجابة موحد).
   - يتم عرض قائمة تسليمات الطلاب في الواجهة.

2. **تصحيح التسليم:**
   - يختار المعلم أحد الطلاب من القائمة.
   - يعرض التطبيق تفاصيل تسليم الطالب (النص، الصور، الوقت...).
   - يمكن للمعلم إدخال الدرجة والتعليق ثم الضغط على زر "تأكيد التصحيح".

3. **حفظ التصحيح:**
   - عند الضغط على زر التصحيح، يتم استدعاء usecase `SubmitGradeUseCase` عبر الـ Bloc.
   - يتم تحديث حالة التسليم لهذا الطالب (محليًا أو عند الربط مع السيرفر لاحقًا).
   - ينتقل التطبيق تلقائيًا للطالب التالي أو يعرض رسالة نجاح.

4. **إنهاء التصحيح:**
   - بعد تصحيح جميع التسليمات، يمكن للمعلم إنهاء التصحيح أو العودة لقائمة الواجبات.

---

## 📝 سيناريو عملي متسلسل

### **1. دخول المعلم وتصحيح الواجب**

1. **المعلم يفتح التطبيق**  ⬇️  
2. **ينتقل إلى صفحة الواجبات**  ⬇️  
3. **يختار واجبًا معينًا (مثلاً: واجب الرياضيات)**  ⬇️  
4. **يظهر له زر "عرض التسليمات"**  ⬇️  
5. **عند الضغط، يتم تحميل قائمة تسليمات الطلاب لهذا الواجب**  ⬇️  
6. **يظهر أول طالب في القائمة مع تفاصيل تسليمه**  ⬇️  
7. **المعلم يقرأ الإجابة، يضع درجة وتعليق، ثم يضغط "تأكيد التصحيح"**  ⬇️  
8. **يتم حفظ التصحيح وينتقل التطبيق تلقائيًا للطالب التالي**  ⬇️  
9. **يكرر الخطوة 7-8 حتى ينتهي من جميع الطلاب**  ⬇️  
10. **عند الانتهاء تظهر رسالة "تم تصحيح جميع التسليمات" ويمكنه العودة أو إنهاء الواجب**

---

## 💡 مثال كود (اختصار):

```dart
// BlocProvider في صفحة التصحيح
BlocProvider(
  create: (_) => getIt<SubmissionBloc>()..add(LoadSubmissionData(assignmentId)),
  child: AssignmentCorrectionPage(),
);

// عند تصحيح طالب:
context.read<SubmissionBloc>().add(
  SubmitGrade(
    submissionId: currentSubmission.id,
    grade: '95',
    feedback: 'إجابة ممتازة!'
  ),
);
```

---

## 🖼️ مثال واجهة مختصر (Widget):

```dart
BlocBuilder<SubmissionBloc, SubmissionState>(
  builder: (context, state) {
    if (state is SubmissionLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is SubmissionDataLoaded) {
      final submission = state.students[state.currentStudentIndex];
      return Column(
        children: [
          Text('اسم الطالب: ${submission.studentName}'),
          Text('الإجابة: ${submission.response}'),
          // ... عرض الصور ...
          TextField(
            decoration: InputDecoration(labelText: 'الدرجة'),
            // ...
          ),
          TextField(
            decoration: InputDecoration(labelText: 'تعليق'),
            // ...
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SubmissionBloc>().add(
                SubmitGrade(
                  submissionId: submission.id,
                  grade: '100',
                  feedback: 'عمل رائع!'
                ),
              );
            },
            child: const Text('تأكيد التصحيح'),
          ),
        ],
      );
    } else if (state is SubmissionError) {
      return Center(child: Text(state.message));
    }
    return const SizedBox.shrink();
  },
)
```

---

## 🛠️ ملاحظات تقنية

- **البيانات حالياً وهمية** (mock) ويمكن ربطها مع API حقيقي بسهولة.
- **كل طبقة منفصلة**: الكيان (Entity)، النموذج (Model)، مصدر البيانات (DataSource)، الريبو (Repository)، حالات Bloc.
- **إدارة الأخطاء** تتم عبر Either<Failure, Data> مع رسائل عربية واضحة.
- **الواجهة تدعم التنقل بين الطلاب، التصحيح، وإنهاء التصحيح بسلاسة.**

---

## 🏁 ملخص

هذه الميزة تجعل عملية تصحيح الواجبات سهلة وسريعة للمعلم، مع بنية نظيفة وقابلة للتطوير والربط مع أي Backend مستقبلاً. 
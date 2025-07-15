# Assignment Feature - Presentation Layer

هذا الملف يشرح بالتفصيل كيفية عمل طبقة العرض (presentation) لميزة الواجبات (assignment) في تطبيق المعلم.

---

## 1. نظرة عامة

طبقة العرض مسؤولة عن:
- استقبال تفاعل المستخدم (بحث، إضافة، تصفية...)
- إدارة الحالة عبر BLoC
- عرض البيانات (قائمة الواجبات، تفاصيل، إضافة جديد)
- تمرير الأحداث للطبقات الأدنى (domain)

---

## 2. BLoC Structure

### الملفات:
- `blocs/assignment_bloc.dart` : منطق إدارة الحالة الرئيسي.
- `blocs/assignment_event.dart` : تعريف الأحداث الممكنة (تحميل، إضافة...)
- `blocs/assignment_state.dart` : تعريف حالات الواجهة (تحميل، جاهز، خطأ...)

### التدفق:
1. **الواجهة** (مثلاً صفحة الواجبات) ترسل حدث (Event) مثل `LoadAssignments` أو `AddAssignment` إلى الـBloc.
2. **Bloc** يستقبل الحدث، ويستدعي الـUseCase المناسب من طبقة الدومين.
3. عند اكتمال العملية، يغير Bloc الحالة (`AssignmentLoaded`, `AssignmentError` ...)، فتقوم الواجهة بإعادة البناء تلقائياً.

#### مثال:
```dart
// إرسال حدث تحميل
context.read<AssignmentBloc>().add(LoadAssignments(searchQuery: 'math'));

// Bloc يستقبل الحدث:
on<LoadAssignments>(_onLoadAssignments);

// عند النجاح:
emit(AssignmentLoaded(assignments));
```

---

## 3. الأحداث (Events)
- **LoadAssignments**: تحميل قائمة الواجبات (مع دعم البحث والتصفية)
- **AddAssignment**: إضافة واجب جديد

كل حدث يرث من `AssignmentEvent` ويحتوي على البيانات اللازمة.

---

## 4. الحالات (States)
- **AssignmentInitial**: الحالة الابتدائية
- **AssignmentLoading**: أثناء التحميل
- **AssignmentLoaded**: عند نجاح جلب البيانات (مع قائمة الواجبات)
- **AssignmentError**: عند حدوث خطأ

كل حالة ترث من `AssignmentState`.

---

## 5. الواجهات (UI)

### Pages
- `ui/pages/assignments_page.dart`: الصفحة الرئيسية لعرض قائمة الواجبات، البحث، التصفية، التنقل لإضافة جديد.
- `ui/pages/new_assignment_page.dart`: صفحة إضافة واجب جديد (نموذج إدخال).

### Widgets
- `ui/widgets/assignment_list_tile.dart`: عنصر لعرض واجب واحد في القائمة.
- `ui/widgets/custom_text_form_field.dart`: حقل إدخال مخصص للنماذج.
- `ui/widgets/section_title.dart`, `action_tile.dart`, ...: عناصر تصميمية مساعدة.

---

## 6. تدفق البيانات

1. المستخدم يفتح صفحة الواجبات → يتم بناء BlocProvider للـAssignmentBloc.
2. عند الدخول، يتم إرسال حدث `LoadAssignments` تلقائياً أو عند تفاعل المستخدم (بحث/تصفية).
3. Bloc يغير الحالة إلى `AssignmentLoading` ثم `AssignmentLoaded` عند نجاح الجلب.
4. عند الضغط على إضافة جديد، ينتقل المستخدم لصفحة `new_assignment_page.dart`.
5. عند حفظ النموذج، يتم إرسال حدث `AddAssignment` للـBloc.
6. Bloc يستدعي الدومين لإضافة الواجب، ثم يعيد تحميل القائمة.

---

## 7. ملاحظات
- جميع التفاعلات مع البيانات تمر عبر Bloc فقط (لا يوجد منطق بيانات في الواجهة).
- يمكن اختبار كل جزء من Bloc بسهولة (الوحدة، التكامل).
- جميع الودجتس مصممة لتكون قابلة لإعادة الاستخدام.

---

## 8. مثال مبسط على الاستخدام

```dart
BlocProvider(
  create: (_) => getIt<AssignmentBloc>()..add(const LoadAssignments()),
  child: AssignmentsPage(),
)
```

---

لأي استفسار حول طبقة العرض أو إضافة ميزة جديدة، راجع هذا الملف أو تواصل مع فريق التطوير. 
# Attendance Package

ميزة الحضور والغياب المطورة باستخدام Clean Architecture و BLoC Pattern.

## 🏗️ Architecture

### Domain Layer
- **Entities**: `AttendanceEntity`, `MonthlyAttendanceEntity`
- **Repository Interface**: `AttendanceRepository`
- **Use Cases**: 
  - `GetMonthlyAttendanceUseCase`
  - `GetAttendanceDetailsUseCase`

### Data Layer
- **Models**: `AttendanceModel`, `MonthlyAttendanceModel`
- **Data Sources**: `AttendanceRemoteDataSource`
- **Repository Implementation**: `AttendanceRepositoryImpl`

### Presentation Layer
- **BLoC**: `AttendanceBloc` مع Events و States
- **Pages**: 
  - `AttendancePage` - الصفحة الرئيسية
  - `AttendanceDetailsPage` - صفحة التفاصيل
- **Widgets**: `AttendanceSummaryCard`

## 🚀 Features

### ✅ الميزات المنجزة
- ✅ **Clean Architecture** - فصل واضح بين الطبقات
- ✅ **BLoC Pattern** - إدارة الحالة بشكل فعال
- ✅ **Dependency Injection** - استخدام GetIt
- ✅ **Error Handling** - معالجة الأخطاء باستخدام Either
- ✅ **Responsive Design** - تصميم متجاوب
- ✅ **Animations** - انتقالات سلسة
- ✅ **Theme Integration** - تكامل مع نظام الألوان
- ✅ **Localization** - دعم متعدد اللغات
- ✅ **Mock Data** - بيانات تجريبية للاختبار

### 📱 UI Components
- **Header Section** - عرض ملخص الحضور
- **Summary Cards** - بطاقات إحصائية
- **Attendance List** - قائمة الأشهر
- **Details View** - عرض تفصيلي للحضور
- **Progress Indicators** - مؤشرات التقدم

## 🔧 Usage

### 1. إضافة Dependency
```yaml
dependencies:
  attendance:
    path: packages/attendance
```

### 2. إعداد Dependency Injection
```dart
import 'package:attendance/injection_container.dart';

await setupAttendanceDependencies(getIt);
```

### 3. استخدام في التطبيق
```dart
import 'package:attendance/attendance.dart';

// في صفحة التطبيق
BlocProvider(
  create: (context) => getIt<AttendanceBloc>(),
  child: AttendancePage(),
)
```

## 📊 Data Structure

### Monthly Attendance
```dart
class MonthlyAttendanceEntity {
  final String monthName;
  final int attendanceCount;
  final int absenceCount;
  final int monthNumber;
}
```

### Attendance Details
```dart
class AttendanceEntity {
  final int year;
  final int month;
  final int attendanceCount;
  final int absenceCount;
  final List<int> presentDays;
  final List<int> absentDays;
}
```

## 🎨 UI States

### Loading State
- عرض مؤشر التحميل
- رسالة "جاري التحميل"

### Success State
- عرض البيانات بنجاح
- إحصائيات مفصلة

### Error State
- رسالة خطأ واضحة
- زر إعادة المحاولة

### Empty State
- رسالة "لا توجد بيانات"
- أيقونة توضيحية

## 🔄 BLoC Events

### LoadMonthlyAttendance
```dart
context.read<AttendanceBloc>().add(LoadMonthlyAttendance(2025));
```

### LoadAttendanceDetails
```dart
context.read<AttendanceBloc>().add(LoadAttendanceDetails(2025, 1));
```

## 📱 BLoC States

### AttendanceInitial
- الحالة الأولية

### AttendanceLoading
- حالة التحميل

### MonthlyAttendanceLoaded
- تم تحميل البيانات الشهرية

### AttendanceDetailsLoaded
- تم تحميل التفاصيل

### AttendanceError
- حالة الخطأ مع الرسالة

## 🎯 Best Practices

### ✅ الممارسات المتبعة
- **Single Responsibility** - كل class له مسؤولية واحدة
- **Dependency Inversion** - استخدام interfaces
- **Error Handling** - معالجة شاملة للأخطاء
- **Code Reusability** - إعادة استخدام المكونات
- **Testability** - قابلية الاختبار
- **Maintainability** - سهولة الصيانة

### 📝 Code Quality
- استخدام `const` constructors
- تطبيق `Equatable` للمقارنة
- استخدام `sealed classes` للـ states
- تطبيق `immutable` patterns

## 🔮 Future Enhancements

### 🚧 الميزات المستقبلية
- [ ] **Real API Integration** - ربط مع API حقيقي
- [ ] **Offline Support** - دعم العمل بدون إنترنت
- [ ] **Data Export** - تصدير البيانات
- [ ] **Advanced Filtering** - فلترة متقدمة
- [ ] **Charts & Graphs** - رسوم بيانية
- [ ] **Push Notifications** - إشعارات فورية

## 🧪 Testing

### Unit Tests
```dart
// Test Use Cases
test('should return monthly attendance when successful', () async {
  // Test implementation
});

// Test BLoC
test('should emit [Loading, Loaded] when data is fetched', () async {
  // Test implementation
});
```

### Widget Tests
```dart
// Test UI Components
testWidgets('should display attendance summary', (tester) async {
  // Test implementation
});
```

## 📚 Dependencies

### Core Dependencies
- `flutter_bloc` - إدارة الحالة
- `dartz` - معالجة الأخطاء
- `get_it` - Dependency Injection
- `equatable` - مقارنة الكائنات

### UI Dependencies
- `core` - الألوان والأنماط
- `easy_localization` - الترجمة

## 🔧 Configuration

### Environment Setup
```dart
// في main.dart
await setupAttendanceDependencies(getIt);
```

### Theme Integration
```dart
// استخدام ألوان التطبيق
AppColors.primary
AppTextStyles.h1
AppSpacing.lg
```

## 📞 Support

للاستفسارات أو المساعدة، يرجى التواصل مع فريق التطوير.

---

**تم التطوير باستخدام Clean Architecture و BLoC Pattern** 🚀



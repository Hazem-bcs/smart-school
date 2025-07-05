# تكامل حزمة Auth مع تطبيق المعلم

## نظرة عامة

تم دمج حزمة `auth` من الـ monorepo مع تطبيق `teacher_app` بنجاح. الحزمة توفر وظائف المصادقة الأساسية مثل تسجيل الدخول والتحقق من حالة المصادقة.

## المكونات المدمجة

### 1. Use Cases
- **`LoginUseCase`**: للتعامل مع تسجيل الدخول
- **`CheckAuthStatusUseCase`**: للتحقق من حالة المصادقة الحالية

### 2. Repository Pattern
- **`AuthRepository`**: واجهة للتعامل مع البيانات
- **`AuthRepositoryImpl`**: التنفيذ الفعلي للـ repository

### 3. Data Sources
- **`AuthRemoteDataSource`**: للتعامل مع API
- **`AuthLocalDataSource`**: للتعامل مع التخزين المحلي

## التكامل مع BLoC

### AuthBloc المحدث
```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LoginUseCase loginUseCase;

  AuthBloc({
    required this.checkAuthStatusUseCase,
    required this.loginUseCase,
  }) : super(AuthInitial()) {
    // Event handlers...
  }
}
```

### الأحداث المدعومة
- **`LoginRequested`**: طلب تسجيل الدخول
- **`LogoutRequested`**: طلب تسجيل الخروج
- **`CheckAuthStatus`**: التحقق من حالة المصادقة

### الحالات المدعومة
- **`AuthInitial`**: الحالة الأولية
- **`AuthLoading`**: جاري التحميل
- **`AuthAuthenticated`**: المستخدم مسجل الدخول
- **`AuthUnauthenticated`**: المستخدم غير مسجل الدخول
- **`AuthError`**: حدث خطأ

## Dependency Injection

### إعداد التبعيات
```dart
Future<void> setupDependencies() async {
  // Setup core and auth dependencies
  await core_di.setupCoreDependencies(getIt);
  await auth_di.setupAuthDependencies(getIt);
  
  // Auth BLoC with auth package use cases
  getIt.registerFactory(() => AuthBloc(
    checkAuthStatusUseCase: getIt<CheckAuthStatusUseCase>(),
    loginUseCase: getIt<LoginUseCase>(),
  ));
}
```

## الاستخدام في الصفحات

### تسجيل الدخول
```dart
// في LoginPage
context.read<AuthBloc>().add(
  LoginRequested(
    email: _emailController.text.trim(),
    password: _passwordController.text,
  ),
);

// الاستماع للنتيجة
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      context.goToClasses();
    } else if (state is AuthError) {
      // عرض رسالة الخطأ
    }
  },
  child: // ...
)
```

### التحقق من حالة المصادقة
```dart
// عند بدء التطبيق
context.read<AuthBloc>().add(CheckAuthStatus());

// الاستماع للنتيجة
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // المستخدم مسجل الدخول - انتقل للصفحة الرئيسية
    } else if (state is AuthUnauthenticated) {
      // المستخدم غير مسجل الدخول - انتقل لصفحة تسجيل الدخول
    }
  },
  child: // ...
)
```

## المميزات

### 1. Error Handling
- معالجة شاملة للأخطاء باستخدام `Either<Failure, Success>`
- رسائل خطأ واضحة للمستخدم

### 2. Local Storage
- حفظ بيانات المستخدم محلياً
- التحقق من حالة المصادقة عند إعادة تشغيل التطبيق

### 3. Network Integration
- تكامل مع API الخادم
- معالجة حالات عدم الاتصال

### 4. Clean Architecture
- فصل واضح بين الطبقات
- سهولة الاختبار والصيانة

## إضافة ميزات جديدة

### إضافة Use Case جديد
1. أنشئ الـ use case في حزمة `auth`
2. أضفه إلى `injection_container.dart` في الحزمة
3. استخدمه في `AuthBloc`

### إضافة حدث جديد
1. أضف الحدث في `auth_event.dart`
2. أضف المعالج في `AuthBloc`
3. أضف الحالة المناسبة في `auth_state.dart`

## أفضل الممارسات

1. **استخدام Use Cases**: دائماً استخدم use cases بدلاً من الوصول المباشر للـ repository
2. **Error Handling**: استخدم `Either` لمعالجة الأخطاء
3. **State Management**: استخدم BLoC لإدارة حالة المصادقة
4. **Dependency Injection**: استخدم GetIt لإدارة التبعيات
5. **Testing**: اكتب اختبارات لكل use case و BLoC 
# نظام Splash Page والتحقق من المصادقة

## نظرة عامة

تم تطبيق نظام `SplashPage` بنفس النمط المستخدم في `student_app` للتحقق من حالة المصادقة عند بدء التطبيق وتوجيه المستخدم للصفحة المناسبة.

## كيف يعمل النظام

### 1. تدفق التطبيق
```
App Start → SplashPage → CheckAuthStatus → Navigate Based on Result
```

### 2. منطق التوجيه
- **إذا كان المستخدم مسجل الدخول**: `AuthAuthenticated` → `ClassesPage`
- **إذا لم يكن المستخدم مسجل الدخول**: `AuthUnauthenticated` → `LoginPage`

## المكونات

### SplashPage
```dart
class SplashPage extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    // التحقق من حالة المصادقة عند بدء الصفحة
    context.read<AuthBloc>().add(CheckAuthStatus());
  }
}
```

### BlocListener للاستماع للحالات
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      context.goToClasses();
    } else if (state is AuthUnauthenticated) {
      context.goToLogin();
    }
  },
  child: // ...
)
```

## الإعداد في app.dart

### MultiBlocProvider
```dart
MultiBlocProvider(
  providers: [
    // Connectivity BLoC - ضروري للتطبيق كاملاً
    BlocProvider(
      create: (context) => di.getIt<ConnectivityBloc>(),
    ),
    // Auth BLoC - ضروري للتحقق من حالة المصادقة
    BlocProvider(
      create: (context) => di.getIt<AuthBloc>(),
    ),
  ],
  child: // ...
)
```

### الصفحة الأولية
```dart
MaterialApp(
  initialRoute: AppRoutes.splash, // بدلاً من login
  onGenerateRoute: AppRoutes.generateRoute,
  // ...
)
```

## لماذا AuthBloc في MultiBlocProvider؟

### الأسباب:
1. **SplashPage يحتاج للوصول إلى AuthBloc**: لاستدعاء `CheckAuthStatus`
2. **التحقق من حالة المصادقة عند بدء التطبيق**: ضروري لتحديد الصفحة المناسبة
3. **نفس النمط المستخدم في student_app**: للاتساق

### البدائل المرفوضة:
- ❌ إنشاء AuthBloc في generateRoute: لن يعمل مع SplashPage
- ❌ عدم التحقق من المصادقة: سيؤدي لتجربة مستخدم سيئة

## المميزات

### 1. تجربة مستخدم محسنة
- التحقق التلقائي من حالة المصادقة
- توجيه ذكي للمستخدم
- لا حاجة لإعادة تسجيل الدخول في كل مرة

### 2. أمان محسن
- التحقق من صحة الجلسة
- إعادة توجيه آمنة

### 3. أداء محسن
- تحميل سريع للصفحة المناسبة
- عدم تحميل صفحات غير ضرورية

## الحالات المدعومة

### AuthBloc States
- **`AuthInitial`**: الحالة الأولية
- **`AuthLoading`**: جاري التحقق من المصادقة
- **`AuthAuthenticated`**: المستخدم مسجل الدخول
- **`AuthUnauthenticated`**: المستخدم غير مسجل الدخول
- **`AuthError`**: حدث خطأ

### التوجيه
- **`AuthAuthenticated`** → `ClassesPage`
- **`AuthUnauthenticated`** → `LoginPage`
- **`AuthError`** → `LoginPage` (مع رسالة خطأ)

## إضافة ميزات جديدة

### إضافة صفحة جديدة
1. أضف المسار في `AppRoutes`
2. أضف دالة التنقل في `NavigationExtension`
3. استخدم `context.goToNewPage()` في `SplashPage`

### تعديل منطق التوجيه
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // منطق التوجيه الجديد
      if (user.hasProfile) {
        context.goToHome();
      } else {
        context.goToProfileSetup();
      }
    } else if (state is AuthUnauthenticated) {
      context.goToLogin();
    }
  },
  child: // ...
)
```

## أفضل الممارسات

1. **استخدام BlocListener**: للاستماع للتغييرات في حالة المصادقة
2. **التوجيه الآمن**: استخدام `pushReplacementNamed` لتجنب تراكم الصفحات
3. **معالجة الأخطاء**: عرض رسائل خطأ واضحة للمستخدم
4. **تحسين الأداء**: عدم إعادة التحقق من المصادقة بشكل متكرر
5. **اختبار شامل**: اختبار جميع سيناريوهات المصادقة 
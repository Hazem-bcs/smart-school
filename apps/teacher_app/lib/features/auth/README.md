# 🔐 Authentication Feature

## 📋 نظرة عامة

ميزة المصادقة (Authentication) هي المكون الأساسي المسؤول عن إدارة عمليات تسجيل الدخول والخروج والتحقق من حالة المصادقة في تطبيق المعلم. تم تطوير هذه الميزة وفقاً لمبادئ Clean Architecture مع فصل واضح بين الطبقات.

## 🏗️ هيكل المشروع

```
auth/
├── data/                          # طبقة البيانات
│   ├── data_sources/             # مصادر البيانات
│   │   ├── auth_local_data_source.dart
│   │   └── auth_remote_data_source.dart
│   ├── models/                   # نماذج البيانات
│   │   ├── user_model.dart
│   │   └── auth_response_model.dart
│   └── repositories/             # تنفيذ المستودعات
│       └── auth_repository_impl.dart
├── domain/                       # طبقة المجال
│   ├── entities/                 # الكيانات
│   │   ├── user.dart
│   │   └── auth_response.dart
│   ├── repositories/             # واجهات المستودعات
│   │   └── auth_repository.dart
│   └── usecases/                 # حالات الاستخدام
│       ├── login_usecase.dart
│       ├── logout_usecase.dart
│       └── check_auth_status_usecase.dart
└── presentation/                 # طبقة العرض
    ├── blocs/                    # إدارة الحالة
    │   ├── auth_bloc.dart
    │   ├── auth_event.dart
    │   └── auth_state.dart
    └── ui/                       # واجهة المستخدم
        ├── pages/                # الصفحات
        │   ├── login_page.dart
        │   └── splash_page.dart
        └── widgets/              # المكونات
            ├── auth_button.dart
            ├── auth_card.dart
            ├── auth_logo.dart
            ├── auth_page_layout.dart
            ├── auth_subtitle.dart
            ├── auth_text_field.dart
            ├── auth_title.dart
            ├── login_form.dart
            ├── splash_content.dart
            └── index.dart
```

## 🎯 الميزات الرئيسية

### 1. تسجيل الدخول (Login)
- واجهة تسجيل دخول متجاوبة
- التحقق من صحة البيانات المدخلة
- إدارة حالة التحميل
- معالجة الأخطاء وعرضها للمستخدم

### 2. التحقق من حالة المصادقة (Auth Status Check)
- التحقق التلقائي من حالة المصادقة عند بدء التطبيق
- التوجيه الذكي بناءً على حالة المصادقة
- إدارة الجلسات المحفوظة

### 3. تسجيل الخروج (Logout)
- تسجيل الخروج الآمن
- مسح البيانات المحفوظة
- إعادة التوجيه لصفحة تسجيل الدخول

### 4. نظام Splash Page
- صفحة تحميل أولية
- التحقق من حالة المصادقة
- التوجيه التلقائي للصفحة المناسبة

## 🏛️ Clean Architecture

### Domain Layer (طبقة المجال)

#### Entities (الكيانات)
```dart
// user.dart
class User {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? avatar;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
}

// auth_response.dart
class AuthResponse {
  final String token;
  final String refreshToken;
  final User user;
  final DateTime expiresAt;
  
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
```

#### Repository Interface (واجهة المستودع)
```dart
abstract class AuthRepository {
  Future<Either<String, AuthResponse>> login(String email, String password);
  Future<Either<String, User>> checkAuthStatus();
  Future<void> logout();
  Future<String?> getStoredToken();
  Future<User?> getStoredUser();
}
```

#### Use Cases (حالات الاستخدام)
- **LoginUseCase**: تسجيل الدخول
- **LogoutUseCase**: تسجيل الخروج
- **CheckAuthStatusUseCase**: التحقق من حالة المصادقة

### Data Layer (طبقة البيانات)

#### Data Sources (مصادر البيانات)
- **AuthRemoteDataSource**: التعامل مع API الخادم
- **AuthLocalDataSource**: التعامل مع التخزين المحلي

#### Models (النماذج)
- **UserModel**: نموذج بيانات المستخدم
- **AuthResponseModel**: نموذج استجابة المصادقة

#### Repository Implementation (تنفيذ المستودع)
```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  
  // تنفيذ جميع العمليات المطلوبة
}
```

### Presentation Layer (طبقة العرض)

#### BLoC Pattern (نمط BLoC)
```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // إدارة حالة المصادقة
  // معالجة الأحداث
  // إصدار الحالات الجديدة
}
```

#### Events (الأحداث)
- **LoginRequested**: طلب تسجيل الدخول
- **LogoutRequested**: طلب تسجيل الخروج
- **CheckAuthStatus**: التحقق من حالة المصادقة

#### States (الحالات)
- **AuthInitial**: الحالة الأولية
- **AuthLoading**: جاري التحميل
- **AuthAuthenticated**: مصادقة ناجحة
- **AuthUnauthenticated**: غير مصادق
- **AuthError**: حالة خطأ

## 🎨 واجهة المستخدم

### الصفحات (Pages)

#### 1. SplashPage
```dart
class SplashPage extends StatefulWidget {
  // صفحة التحميل الأولية
  // التحقق من حالة المصادقة
  // التوجيه التلقائي
}
```

**المميزات:**
- تصميم متجاوب (Mobile, Tablet, Desktop)
- عرض شعار التطبيق
- مؤشر تحميل أثناء التحقق من المصادقة
- توجيه ذكي بناءً على حالة المصادقة

#### 2. LoginPage
```dart
class LoginPage extends StatefulWidget {
  // صفحة تسجيل الدخول
  // نموذج إدخال البيانات
  // معالجة الأخطاء
}
```

**المميزات:**
- نموذج تسجيل دخول شامل
- التحقق من صحة البيانات
- إدارة حالة التحميل
- عرض رسائل الخطأ

### المكونات (Widgets)

#### 1. AuthTextField
```dart
class AuthTextField extends StatelessWidget {
  // حقل إدخال مخصص للمصادقة
  // دعم الأيقونات
  // التحقق من صحة البيانات
}
```

#### 2. AuthButton
```dart
class AuthButton extends StatelessWidget {
  // زر مخصص للمصادقة
  // دعم حالة التحميل
  // تصميم متجاوب
}
```

#### 3. AuthPageLayout
```dart
class AuthPageLayout extends StatelessWidget {
  // تخطيط صفحة المصادقة
  // دعم التصميم المتجاوب
  // تنظيم العناصر
}
```

#### 4. LoginForm
```dart
class LoginForm extends StatefulWidget {
  // نموذج تسجيل الدخول
  // إدارة الحقول
  // التحقق من الصحة
  // إرسال البيانات
}
```

## 🔄 تدفق العمل

### 1. بدء التطبيق
```
App Start → SplashPage → CheckAuthStatus → Navigate Based on Result
```

### 2. تسجيل الدخول
```
LoginPage → User Input → Validation → LoginRequested Event → AuthBloc → API Call → Success/Error
```

### 3. التحقق من المصادقة
```
SplashPage → CheckAuthStatus Event → AuthBloc → Local Storage Check → API Validation → Result
```

### 4. تسجيل الخروج
```
Any Page → LogoutRequested Event → AuthBloc → Clear Local Data → Navigate to Login
```

## 🛡️ الأمان

### 1. التحقق من صحة البيانات
- التحقق من تنسيق البريد الإلكتروني
- التحقق من طول كلمة المرور
- منع إدخال البيانات الفارغة

### 2. إدارة الجلسات
- حفظ التوكن محلياً
- التحقق من انتهاء صلاحية التوكن
- إعادة المصادقة عند الحاجة

### 3. معالجة الأخطاء
- عرض رسائل خطأ واضحة
- عدم كشف معلومات حساسة
- إعادة المحاولة عند فشل الشبكة

## 📱 التصميم المتجاوب

### Breakpoints المدعومة
- **Mobile**: < 768px
- **Tablet**: 768px - 1024px
- **Desktop**: > 1024px

### المكونات المتجاوبة
- **ResponsiveText**: نص متجاوب
- **ResponsiveIcon**: أيقونة متجاوبة
- **ResponsiveSpacing**: مسافات متجاوبة
- **ResponsiveLayout**: تخطيط متجاوب

## 🌐 الترجمة والدعم اللغوي

### المفاتيح المدعومة
```dart
'auth.sign_in'           // تسجيل الدخول
'auth.email'             // البريد الإلكتروني
'auth.password'          // كلمة المرور
'validation.required_field'      // حقل مطلوب
'validation.invalid_email'       // بريد إلكتروني غير صحيح
'validation.password_too_short'  // كلمة مرور قصيرة جداً
```

## 🔧 الإعداد والتكوين

### 1. Dependency Injection
```dart
// في injection_container.dart
sl.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ),
);

sl.registerLazySingleton(() => LoginUseCase(sl()));
sl.registerLazySingleton(() => LogoutUseCase(sl()));
sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));

sl.registerFactory(() => AuthBloc(
  loginUseCase: sl(),
  logoutUseCase: sl(),
  checkAuthStatusUseCase: sl(),
));
```

### 2. إعداد BLoC Provider
```dart
MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) => di.getIt<AuthBloc>(),
    ),
  ],
  child: MaterialApp(
    initialRoute: AppRoutes.splash,
    onGenerateRoute: AppRoutes.generateRoute,
  ),
)
```

### 3. إعداد المسارات
```dart
// في app_routes.dart
class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }
}
```

## 🧪 الاختبار

### اختبارات الوحدة
- اختبار Use Cases
- اختبار Repository
- اختبار Data Sources

### اختبارات التكامل
- اختبار BLoC
- اختبار UI Components
- اختبار Navigation

### اختبارات القبول
- اختبار سيناريوهات تسجيل الدخول
- اختبار معالجة الأخطاء
- اختبار التصميم المتجاوب

## 🚀 الاستخدام

### 1. تسجيل الدخول
```dart
// في أي صفحة
context.read<AuthBloc>().add(
  LoginRequested(
    email: 'teacher@school.com',
    password: 'password123',
  ),
);
```

### 2. التحقق من حالة المصادقة
```dart
// في SplashPage
context.read<AuthBloc>().add(CheckAuthStatus());
```

### 3. تسجيل الخروج
```dart
// في أي صفحة
context.read<AuthBloc>().add(LogoutRequested());
```

### 4. الاستماع للحالات
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // التوجيه للصفحة الرئيسية
    } else if (state is AuthUnauthenticated) {
      // التوجيه لصفحة تسجيل الدخول
    } else if (state is AuthError) {
      // عرض رسالة الخطأ
    }
  },
  child: // ...
)
```

## 📈 التطوير المستقبلي

### الميزات المقترحة
1. **تسجيل الدخول بالبصمة**: دعم المصادقة البيومترية
2. **المصادقة الثنائية**: إضافة طبقة أمان إضافية
3. **تذكر تسجيل الدخول**: خيار "تذكرني"
4. **استعادة كلمة المرور**: إرسال رابط إعادة التعيين
5. **تسجيل الدخول الاجتماعي**: Google, Apple, Microsoft

### التحسينات التقنية
1. **Token Refresh**: تجديد التوكن تلقائياً
2. **Offline Support**: دعم العمل بدون إنترنت
3. **Analytics**: تتبع استخدام المصادقة
4. **Security Audit**: مراجعة أمنية شاملة

## 📚 المراجع

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Flutter Responsive](https://pub.dev/packages/sizer)
- [Easy Localization](https://pub.dev/packages/easy_localization)

## 🤝 المساهمة

للمساهمة في تطوير ميزة المصادقة:

1. اتبع مبادئ Clean Architecture
2. اكتب اختبارات شاملة
3. تأكد من التصميم المتجاوب
4. أضف تعليقات توضيحية
5. اتبع معايير الترميز

---

**تم تطوير هذه الميزة بواسطة فريق Smart School** 
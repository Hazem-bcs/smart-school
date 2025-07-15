# Core Package - Network & Theme Layer Usage

هذه الوثيقة تشرح كيفية استخدام نظام الشبكة (network) ونظام الثيم الموحد (theme) الاحترافي الموجودين في حزمة core ضمن مشروعك.

---

## 1. DioClient (إرسال واستقبال البيانات عبر الشبكة)

- **الاستيراد:**
  ```dart
  import 'package:core/network/dio_client.dart';
  ```
- **الاستخدام:**
  ```dart
  final dioClient = DioClient(baseUrl: 'https://api.example.com');
  final result = await dioClient.get('/endpoint');
  result.fold(
    (failure) => handleError(failure),
    (response) => handleSuccess(response.data),
  );
  ```
- **ملاحظة:**
  - جميع الدوال ترجع `Either<Failure, Response>` لسهولة التعامل مع الأخطاء.
  - يمكنك تمرير دالة getToken لإضافة Authorization header تلقائياً.

---

## 2. NetworkInfo (التحقق من الاتصال بالإنترنت)

- **الاستيراد:**
  ```dart
  import 'package:core/network/network_info.dart';
  ```
- **الاستخدام:**
  ```dart
  final networkInfo = NetworkInfoImpl(Connectivity());
  final isConnected = await networkInfo.isConnected;
  ```

---

## 3. ConnectivityBloc (مراقبة الاتصال بالإنترنت)

- **الاستيراد:**
  ```dart
  import 'package:core/blocs/sensitive_connectivity/connectivity_bloc.dart';
  ```
- **التسجيل في getIt:**
  ```dart
  getIt.registerFactory(() => ConnectivityBloc(connectivity: Connectivity()));
  ```
- **الاستخدام في MultiBlocProvider:**
  ```dart
  BlocProvider(
    create: (context) => getIt<ConnectivityBloc>(),
    child: ...
  )
  ```

---

## 4. ConnectivityListener (Widget لمراقبة الاتصال)

- **الاستيراد:**
  ```dart
  import 'package:core/widgets/connectivity_listener.dart';
  ```
- **الاستخدام:**
  ```dart
  builder: (context, child) => ConnectivityListener(child: child!),
  ```

---

## 5. ThemeBloc & Theme الموحد (إدارة وتبديل الثيم)

- **الاستيراد:**
  ```dart
  import 'package:core/blocs/theme/theme_bloc.dart';
  import 'package:core/blocs/theme/theme_event.dart';
  import 'package:core/blocs/theme/theme_state.dart';
  ```
- **التسجيل في getIt (اختياري):**
  ```dart
  getIt.registerFactory(() => ThemeBloc());
  ```
- **الاستخدام في MultiBlocProvider:**
  ```dart
  BlocProvider(
    create: (context) => ThemeBloc()..add(InitializeTheme()),
    child: ...
  )
  ```
- **استخدام الثيم في MaterialApp:**
  ```dart
  BlocBuilder<ThemeBloc, ThemeState>(
    builder: (context, state) {
      final theme = state is ThemeLoaded ? state.currentTheme : ThemeData.light();
      final themeMode = state is ThemeLoaded ? state.themeMode : ThemeMode.system;
      return MaterialApp(
        theme: theme,
        darkTheme: theme,
        themeMode: themeMode,
        // ...
      );
    },
  )
  ```
- **تبديل الثيم (مثال):**
```dart
  context.read<ThemeBloc>().add(ToggleTheme());
```

---

> **ملاحظة:**
> جميع التطبيقات ستستخدم نفس الثيم الموحد (ألوان وتخصيصات teacher) بشكل افتراضي. إذا رغبت في تخصيص الثيم لاحقًا، يمكنك تعديل AppTheme أو ThemeManager في core.

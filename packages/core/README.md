# Core Package - Network Layer Usage

هذه الوثيقة تشرح كيفية استخدام نظام الشبكة الاحترافي الموجود في حزمة core ضمن مشروعك.

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

> **ملاحظة:**
> هذه الوثيقة توضح فقط نظام الشبكة في core. عند تطوير أو نقل ميزات أخرى (auth, theme, ...)، سيتم تحديث هذا الملف.

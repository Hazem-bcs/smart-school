# Settings Feature - Clean Architecture Implementation

## 📋 Overview
تم إعادة بناء ميزة Settings وفقاً لقالب Clean Architecture مع التركيز على معالجة تسجيل الخروج بالطريقة المطلوبة.

## 🏗️ Architecture

### **Domain Layer:**
- **Entities:** `LogoutEntity` - يمثل نتيجة تسجيل الخروج
- **Repositories:** `SettingsRepository` - واجهة للوصول للبيانات
- **Use Cases:** `LogoutUseCase` - منطق الأعمال لتسجيل الخروج

### **Data Layer:**
- **Models:** `LogoutModel` - نموذج البيانات مع JSON parsing
- **Data Sources:** 
  - `SettingsRemoteDataSource` - للتواصل مع السيرفر
  - `SettingsLocalDataSource` - لإدارة البيانات المحلية
- **Repository Implementation:** `SettingsRepositoryImpl` - تنفيذ الواجهة

### **Presentation Layer:**
- **BLoC:** `SettingsBloc` - إدارة الحالة
- **Events:** `LogoutRequested` - أحداث تسجيل الخروج
- **States:** `LogoutLoading`, `LogoutSuccess`, `LogoutFailure` - حالات مختلفة
- **UI Components:** صفحات و widgets منفصلة

## 🔄 Logout Flow

### **1. طلب تسجيل الخروج:**
```dart
// المستخدم يضغط على زر تسجيل الخروج
context.read<SettingsBloc>().add(LogoutRequested(userId: userId));
```

### **2. معالجة الطلب:**
```dart
// BLoC يرسل الطلب إلى Use Case
final result = await logoutUseCase(event.userId);
```

### **3. التواصل مع السيرفر:**
```dart
// Remote Data Source يتواصل مع السيرفر
Future<Either<Failure, LogoutModel>> logout(String userId)
```

### **4. معالجة النتيجة:**
- **في حالة النجاح:** مسح `user_id` من SharedPreferences
- **في حالة الفشل:** إبقاء المستخدم في الشاشة الحالية مع رسالة خطأ

### **5. التوجيه:**
- **بعد النجاح:** التوجيه إلى صفحة تسجيل الدخول
- **في حالة الفشل:** إظهار رسالة خطأ مع إمكانية إعادة المحاولة

## 🎯 Key Features

### **1. Logout System:**
- **Server Communication:** إرسال `user_id` إلى السيرفر
- **Local Data Cleanup:** مسح `user_id` من SharedPreferences
- **Error Handling:** معالجة شاملة للأخطاء
- **User Feedback:** رسائل نجاح وخطأ واضحة

### **2. Error Handling:**
- **Network Errors:** أخطاء الاتصال بالخادم
- **Timeout Errors:** انتهاء مهلة الاتصال
- **Parsing Errors:** أخطاء تحليل البيانات
- **Retry Mechanism:** إمكانية إعادة المحاولة

### **3. UI States:**
- **Loading State:** عرض مؤشر التحميل
- **Error State:** عرض رسالة الخطأ مع زر إعادة المحاولة
- **Success State:** رسالة نجاح والتوجيه التلقائي

## 📁 File Structure

```
settings/
├── data/
│   ├── data_sources/
│   │   ├── local/
│   │   │   └── settings_local_data_source.dart
│   │   └── remote/
│   │       └── settings_remote_data_source.dart
│   ├── models/
│   │   └── logout_model.dart
│   └── repositories_impl/
│       └── settings_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── logout_entity.dart
│   ├── repositories/
│   │   └── settings_repository.dart
│   └── usecases/
│       └── logout_usecase.dart
├── presentation/
│   ├── blocs/
│   │   ├── settings_bloc.dart
│   │   ├── settings_event.dart
│   │   └── settings_state.dart
│   ├── ui/
│   │   ├── pages/
│   │   │   └── settings_page.dart
│   │   └── widgets/
│   │       ├── index.dart
│   │       ├── settings_app_bar.dart
│   │       ├── settings_loading_state.dart
│   │       └── settings_error_state.dart
│   └── widgets/
│       ├── index.dart
│       ├── profile_card.dart
│       └── settings_section.dart
└── README.md
```

## 🔧 Implementation Details

### **1. Error Handling Strategy:**
```dart
// في Data Source Layer
if (DateTime.now().millisecondsSinceEpoch % 7 == 0) {
  return Left(ServerFailure(message: 'فشل في الاتصال بالخادم'));
}
```

### **2. Local Data Management:**
```dart
// مسح user_id من SharedPreferences
await localDataSource.clearUserId();
```

### **3. Navigation Logic:**
```dart
// التوجيه بعد النجاح
Future.delayed(const Duration(seconds: 2), () {
  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
});
```

### **4. User Feedback:**
```dart
// رسائل النجاح والخطأ
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(message),
    backgroundColor: Colors.green[600],
    action: SnackBarAction(
      label: 'إعادة المحاولة',
      onPressed: _performLogout,
    ),
  ),
);
```

## 🚀 Benefits

### **1. Clean Architecture:**
- **Separation of Concerns:** فصل واضح للمسؤوليات
- **Dependency Injection:** حقن التبعيات بشكل صحيح
- **Testability:** قابلية الاختبار العالية

### **2. Error Handling:**
- **Comprehensive:** معالجة شاملة لجميع أنواع الأخطاء
- **User-Friendly:** رسائل خطأ واضحة ومفيدة
- **Recovery:** إمكانية التعافي من الأخطاء

### **3. User Experience:**
- **Loading States:** مؤشرات تحميل واضحة
- **Success Feedback:** رسائل نجاح واضحة
- **Error Recovery:** إمكانية إعادة المحاولة

### **4. Maintainability:**
- **Modular Design:** تصميم وحدات منفصلة
- **Clear Structure:** هيكل واضح ومنظم
- **Documentation:** توثيق شامل

## 🧪 Testing Strategy

### **1. Unit Tests:**
- **Use Cases:** اختبار منطق الأعمال
- **Repository:** اختبار طبقة البيانات
- **Data Sources:** اختبار مصادر البيانات

### **2. Widget Tests:**
- **UI Components:** اختبار واجهة المستخدم
- **State Management:** اختبار إدارة الحالة
- **User Interactions:** اختبار تفاعلات المستخدم

### **3. Integration Tests:**
- **End-to-End:** اختبار التدفق الكامل
- **Error Scenarios:** اختبار سيناريوهات الخطأ
- **Navigation:** اختبار التنقل

## 🔄 Data Flow

```
User Action → Event → BLoC → Use Case → Repository → Data Source
                ↓
UI Update ← State ← BLoC ← Use Case ← Repository ← Data Source
```

## 🎯 Future Enhancements

### **1. Additional Settings:**
- **Theme Management:** إدارة الثيمات
- **Language Management:** إدارة اللغات
- **Notification Settings:** إعدادات الإشعارات

### **2. Security Features:**
- **Biometric Authentication:** المصادقة البيومترية
- **Session Management:** إدارة الجلسات
- **Data Encryption:** تشفير البيانات

### **3. Performance Optimizations:**
- **Caching Strategy:** استراتيجية التخزين المؤقت
- **Lazy Loading:** التحميل الكسول
- **Memory Management:** إدارة الذاكرة

الآن ميزة Settings مبنية وفقاً لأفضل الممارسات مع معالجة شاملة لتسجيل الخروج! 🎯 
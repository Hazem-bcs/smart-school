# دليل نظام الاتصال (Connectivity) في تطبيق المعلم

## 🔄 نظرة عامة على النظام

نظام الاتصال في تطبيق المعلم يعتمد على **BLoC Pattern** لمراقبة حالة الاتصال بالإنترنت وإدارة التغييرات بشكل ذكي.

## 🏗️ البنية الأساسية

### 1. **ConnectivityBloc** - المحرك الرئيسي
```dart
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState>
```

**المكونات الأساسية:**
- `Connectivity _connectivity` - مكتبة connectivity_plus
- `StreamSubscription<ConnectivityResult> _connectivitySubscription` - مراقب التغييرات
- `Timer? _retryTimer` - مؤقت إعادة المحاولة
- `int _retryCount` - عداد المحاولات (الحد الأقصى: 3)
- `Duration retryDelay` - تأخير إعادة المحاولة (5 ثواني)

## 📊 الحالات (States) الممكنة

### **ConnectivityInitial**
- الحالة الأولية عند بدء التطبيق
- لا توجد معلومات عن الاتصال بعد

### **ConnectivityOnline**
```dart
class ConnectivityOnline extends ConnectivityState {
  final String connectionType;  // WiFi, Mobile, VPN, etc.
  final DateTime timestamp;     // وقت الاتصال
}
```

### **ConnectivityOffline**
```dart
class ConnectivityOffline extends ConnectivityState {
  final DateTime timestamp;     // وقت فقدان الاتصال
  final String? lastKnownType;  // نوع الاتصال السابق
}
```

### **ConnectivityRetrying**
```dart
class ConnectivityRetrying extends ConnectivityState {
  final int retryCount;         // عدد المحاولات الحالية
  final int maxRetries;         // الحد الأقصى (3)
  final DateTime timestamp;     // وقت المحاولة
}
```

### **ConnectivityMaxRetriesExceeded**
```dart
class ConnectivityMaxRetriesExceeded extends ConnectivityState {
  final DateTime timestamp;     // وقت تجاوز الحد
  final int retryCount;         // عدد المحاولات الفاشلة
}
```

### **ConnectivityError**
```dart
class ConnectivityError extends ConnectivityState {
  final String message;         // رسالة الخطأ
  final DateTime timestamp;     // وقت حدوث الخطأ
}
```

## 🎯 الأحداث (Events) المدعومة

### **ConnectivityStatusChanged**
```dart
class ConnectivityStatusChanged extends ConnectivityEvent {
  final ConnectivityResult result;  // نتيجة فحص الاتصال
}
```

### **CheckConnectivity**
```dart
class CheckConnectivity extends ConnectivityEvent {
  // فحص يدوي لحالة الاتصال
}
```

### **RetryConnection**
```dart
class RetryConnection extends ConnectivityEvent {
  // إعادة محاولة الاتصال
}
```

## ⚙️ آلية العمل

### **1. عند بدء التطبيق:**
```dart
// 1. التحقق الأولي من الاتصال
_checkInitialConnectivity()

// 2. بدء مراقبة التغييرات
_connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
  add(ConnectivityStatusChanged(result));
});
```

### **2. عند تغيير حالة الاتصال:**
```dart
void _onConnectivityStatusChanged(ConnectivityStatusChanged event, Emitter<ConnectivityState> emit) {
  _retryCount = 0; // إعادة تعيين العداد
  
  if (event.result == ConnectivityResult.mobile || 
      event.result == ConnectivityResult.wifi || 
      event.result == ConnectivityResult.vpn) {
    // متصل بالإنترنت
    emit(ConnectivityOnline(...));
    _showToast('lbl_has_internet'.tr(), isError: false);
  } else if (event.result == ConnectivityResult.none) {
    // غير متصل
    emit(ConnectivityOffline(...));
    _showToast('lbl_lost_internet'.tr(), isError: true);
    _scheduleRetry(); // جدولة إعادة المحاولة
  }
}
```

### **3. آلية إعادة المحاولة:**
```dart
void _scheduleRetry() {
  _retryTimer?.cancel();
  _retryTimer = Timer(retryDelay, () { // 5 ثواني
    if (state is ConnectivityOffline) {
      add(RetryConnection());
    }
  });
}
```

### **4. عملية إعادة المحاولة:**
```dart
void _onRetryConnection(RetryConnection event, Emitter<ConnectivityState> emit) async {
  if (_retryCount >= maxRetries) {
    emit(ConnectivityMaxRetriesExceeded(...));
    return;
  }

  _retryCount++;
  emit(ConnectivityRetrying(...));

  try {
    final result = await _connectivity.checkConnectivity();
    if (result != ConnectivityResult.none) {
      add(ConnectivityStatusChanged(result));
    } else {
      _scheduleRetry(); // محاولة أخرى
    }
  } catch (e) {
    emit(ConnectivityError('Retry failed: $e'));
    _scheduleRetry();
  }
}
```

## 🌐 أنواع الاتصال المدعومة

```dart
String _getConnectionType(ConnectivityResult result) {
  switch (result) {
    case ConnectivityResult.wifi: return 'WiFi';
    case ConnectivityResult.mobile: return 'Mobile';
    case ConnectivityResult.vpn: return 'VPN';
    case ConnectivityResult.ethernet: return 'Ethernet';
    case ConnectivityResult.bluetooth: return 'Bluetooth';
    case ConnectivityResult.none: return 'None';
    default: return 'Unknown';
  }
}
```

## 🔔 الإشعارات (Toast Messages)

```dart
void _showToast(String message, {required bool isError}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: isError ? Colors.red : Colors.green,
    textColor: Colors.white,
  );
}
```

## 🎨 واجهة المستخدم - ConnectivityListener

```dart
class ConnectivityListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityOffline) {
          // إشعار باللون الأحمر
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('connectivity.offline'.tr()))
          );
        } else if (state is ConnectivityOnline) {
          // إشعار باللون الأخضر
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('connectivity.online'.tr()))
          );
        } else if (state is ConnectivityRetrying) {
          // إشعار باللون البرتقالي
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('connectivity.retrying'.tr()))
          );
        } else if (state is ConnectivityMaxRetriesExceeded) {
          // إشعار مع زر إعادة المحاولة
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('connectivity.max_retries_exceeded'.tr()),
              action: SnackBarAction(
                label: 'connectivity.retry'.tr(),
                onPressed: () {
                  context.read<ConnectivityBloc>().add(const CheckConnectivity());
                },
              ),
            ),
          );
        }
      },
      child: child,
    );
  }
}
```

## 🔧 الإعداد والتشغيل

### **1. تسجيل BLoC في Dependency Injection:**
```dart
// في injection_container.dart
getIt.registerFactory(() => ConnectivityBloc(connectivity: Connectivity()));
```

### **2. إعداد BlocProvider في التطبيق:**
```dart
// في app.dart
BlocProvider(
  create: (context) => di.getIt<ConnectivityBloc>(),
),
```

### **3. استخدام ConnectivityListener:**
```dart
// في app.dart
home: ConnectivityListener(
  child: const LoginPage(),
),
```

## 📱 كيفية الاستخدام في الكود

### **مراقبة حالة الاتصال:**
```dart
BlocBuilder<ConnectivityBloc, ConnectivityState>(
  builder: (context, state) {
    if (state is ConnectivityOnline) {
      return Text('متصل: ${state.connectionType}');
    } else if (state is ConnectivityOffline) {
      return Text('غير متصل');
    }
    return Text('جاري التحقق...');
  },
)
```

### **إرسال حدث فحص يدوي:**
```dart
context.read<ConnectivityBloc>().add(const CheckConnectivity());
```

### **إرسال حدث إعادة المحاولة:**
```dart
context.read<ConnectivityBloc>().add(const RetryConnection());
```

## 🎯 المميزات

1. **مراقبة مستمرة** - يراقب التغييرات تلقائياً
2. **إعادة المحاولة الذكية** - يحاول إعادة الاتصال تلقائياً
3. **إشعارات تفاعلية** - يظهر إشعارات للمستخدم
4. **إدارة الحالات** - يدير جميع حالات الاتصال
5. **دعم متعدد اللغات** - ترجمات بالعربية والإنجليزية
6. **أداء محسن** - يستخدم StreamSubscription للكفاءة

## 🔍 استكشاف الأخطاء

### **مشاكل شائعة:**
1. **عدم ظهور الإشعارات** - تأكد من تسجيل ConnectivityBloc
2. **عدم عمل إعادة المحاولة** - تحقق من إعدادات Timer
3. **أخطاء في الترجمة** - تأكد من وجود مفاتيح الترجمة

### **نصائح للتصحيح:**
- استخدم `print` أو `debugPrint` لتتبع الحالات
- تحقق من logs للتأكد من عمل StreamSubscription
- اختبر على أجهزة مختلفة (WiFi, Mobile Data)

## 📈 تحسينات مستقبلية

1. **إعدادات قابلة للتخصيص** - عدد المحاولات والوقت
2. **إحصائيات الاتصال** - وقت الاتصال والفصل
3. **وضع الطيران** - دعم إعدادات الطيران
4. **تخزين محلي** - حفظ حالة الاتصال
5. **إشعارات متقدمة** - إشعارات push للاتصال 
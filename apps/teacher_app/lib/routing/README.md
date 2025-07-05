# نظام التوجيه النظيف (Clean Routing System)

## نظرة عامة

تم إنشاء نظام توجيه نظيف وبسيط لتحسين الأداء وسهولة الصيانة.

## المميزات

### 1. تهيئة BLoC داخل generateRoute
- يتم تهيئة كل BLoC عند الحاجة فقط (lazy loading)
- تحسين الأداء عن طريق عدم تحميل جميع BLoCs في البداية
- استثناء: `ConnectivityBloc` يبقى في `MultiBlocProvider` لأنه ضروري للتطبيق كاملاً

### 2. Navigation Extension
- extension بسيط ونظيف للتنقل
- استدعاءات سهلة ومباشرة
- دعم تمرير المعاملات

## الاستخدام

### التنقل الأساسي
```dart
// الذهاب لصفحة تسجيل الدخول
context.goToLogin();

// الذهاب لصفحة الفصول
context.goToClasses();

// الذهاب للصفحة الرئيسية مع اسم الفصل
context.goToHome(className: 'Class A');

// الذهاب للملف الشخصي
context.goToProfile();

// الذهاب للإعدادات
context.goToSettings();

// العودة للصفحة السابقة
context.goBack();
```

### إضافة مسار جديد
1. أضف اسم المسار في `AppRoutes`:
```dart
static const String newPage = '/new-page';
```

2. أضف المنطق في `generateRoute`:
```dart
} else if (routeName == newPage) {
  return MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) => NewPageBloc(),
      child: const NewPage(),
    ),
    settings: settings,
  );
}
```

3. أضف دالة التنقل في `NavigationExtension`:
```dart
void goToNewPage() {
  Navigator.pushNamed(this, AppRoutes.newPage);
}
```

## هيكل الملفات

```
lib/routing/
├── app_routes.dart          # تعريف المسارات و generateRoute
├── navigation_extension.dart # extension للتنقل
└── README.md               # هذا الملف
```

## أفضل الممارسات

1. **تهيئة BLoC**: دائماً استخدم `BlocProvider` داخل `generateRoute`
2. **ConnectivityBloc**: يبقى في `MultiBlocProvider` لأنه ضروري للتطبيق كاملاً
3. **تمرير المعاملات**: استخدم `arguments` لتمرير البيانات
4. **التنقل**: استخدم extension بدلاً من `Navigator` مباشرة
5. **الأداء**: BLoCs تُحمل عند الحاجة فقط 
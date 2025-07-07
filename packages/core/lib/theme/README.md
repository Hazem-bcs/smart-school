# Smart School Theme System

نظام ثيم شامل ومتقدم لتطبيقات Smart School، يوفر إدارة مركزية للألوان والأنماط والمسافات مع دعم كامل للثيمات الفاتحة والداكنة.

## 🎨 المكونات الرئيسية

### 1. **AppColors** - إدارة الألوان
```dart
import 'package:core/theme/index.dart';

// الألوان الأساسية
AppColors.primary      // اللون الأساسي
AppColors.secondary    // اللون الثانوي
AppColors.accent       // لون التمييز

// ألوان دلالية
AppColors.success      // لون النجاح
AppColors.warning      // لون التحذير
AppColors.error        // لون الخطأ
AppColors.info         // لون المعلومات

// ألوان خاصة بالتطبيقات
AppColors.teacherAccent  // لون تطبيق المعلم
AppColors.studentAccent  // لون تطبيق الطالب
AppColors.parentAccent   // لون تطبيق الأهل
```

### 2. **AppTextStyles** - أنماط النصوص
```dart
// أنماط العناوين
AppTextStyles.h1, h2, h3, h4, h5

// أنماط النصوص الأساسية
AppTextStyles.bodyLarge, bodyMedium, bodySmall

// أنماط التسميات
AppTextStyles.labelLarge, labelMedium, labelSmall

// أنماط الأزرار
AppTextStyles.buttonPrimary, buttonSecondary

// إنشاء أنماط مخصصة
AppTextStyles.create(
  fontSize: 16.0,
  fontWeight: AppTextStyles.semiBold,
  color: AppColors.primary,
);
```

### 3. **AppSpacing** - إدارة المسافات والأبعاد
```dart
// المسافات الأساسية
AppSpacing.xs, sm, md, base, lg, xl, xl2, xl3, xl4, xl5, xl6

// الحشوات الجاهزة
AppSpacing.screenPadding      // حشوة الشاشة
AppSpacing.cardPadding        // حشوة البطاقة
AppSpacing.buttonPadding      // حشوة الزر

// الهوامش الجاهزة
AppSpacing.baseMargin         // هامش أساسي
AppSpacing.screenMargin       // هامش الشاشة

// نصف قطر الحدود
AppSpacing.baseBorderRadius   // نصف قطر أساسي
AppSpacing.circularBorderRadius // نصف قطر دائري

// أحجام الأيقونات
AppSpacing.baseIcon           // حجم أيقونة أساسي
AppSpacing.lgIcon             // حجم أيقونة كبير
```

### 4. **AppTheme** - إدارة الثيمات
```dart
// الثيمات الجاهزة
AppTheme.lightTheme           // الثيم الفاتح
AppTheme.darkTheme            // الثيم الداكن

// الحصول على الثيم حسب السطوع
AppTheme.getTheme(Brightness.light)
AppTheme.getTheme(Brightness.dark)

// الحصول على ثيم النظام
AppTheme.getSystemTheme()

// إنشاء ثيم مخصص
AppTheme.createAppTheme(
  brightness: Brightness.light,
  accentColor: AppColors.teacherAccent,
);
```

### 5. **ThemeManager** - إدارة حالة الثيم
```dart
final themeManager = ThemeManager();

// تهيئة مدير الثيم
await themeManager.initialize();

// تغيير الثيم
await themeManager.setThemeMode(ThemeMode.light);
await themeManager.setThemeMode(ThemeMode.dark);
await themeManager.setThemeMode(ThemeMode.system);

// تبديل الثيم
await themeManager.toggleTheme();

// الحصول على الثيم الحالي
ThemeData currentTheme = themeManager.getCurrentTheme();
```

## 🚀 الاستخدام في التطبيقات

### 1. **تطبيق المعلم**
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
  // ...
)
```

### 2. **تطبيق الطالب**
```dart
MaterialApp(
  theme: AppTheme.createAppTheme(
    brightness: Brightness.light,
    accentColor: AppColors.studentAccent,
  ),
  darkTheme: AppTheme.createAppTheme(
    brightness: Brightness.dark,
    accentColor: AppColors.studentAccent,
  ),
  themeMode: ThemeMode.system,
  // ...
)
```

### 3. **تطبيق الأهل**
```dart
MaterialApp(
  theme: AppTheme.createAppTheme(
    brightness: Brightness.light,
    accentColor: AppColors.parentAccent,
  ),
  darkTheme: AppTheme.createAppTheme(
    brightness: Brightness.dark,
    accentColor: AppColors.parentAccent,
  ),
  themeMode: ThemeMode.system,
  // ...
)
```

## 🎯 الاستخدام في الواجهات

### 1. **استخدام الألوان**
```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Hello World',
    style: TextStyle(color: AppColors.white),
  ),
)
```

### 2. **استخدام أنماط النصوص**
```dart
Text(
  'عنوان رئيسي',
  style: AppTextStyles.h1.copyWith(
    color: AppColors.primary,
  ),
)
```

### 3. **استخدام المسافات**
```dart
Container(
  padding: AppSpacing.screenPadding,
  margin: AppSpacing.baseMargin,
  child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.baseBorderRadius,
    ),
    child: Padding(
      padding: AppSpacing.cardPadding,
      child: Text('محتوى البطاقة'),
    ),
  ),
)
```

### 4. **استخدام الثيم الحالي**
```dart
Widget build(BuildContext context) {
  return Container(
    color: Theme.of(context).colorScheme.surface,
    child: Text(
      'نص متغير حسب الثيم',
      style: Theme.of(context).textTheme.bodyLarge,
    ),
  );
}
```

## 🔧 التخصيص

### 1. **إضافة ألوان جديدة**
```dart
// في AppColors
static const Color customColor = Color(0xFF123456);
```

### 2. **إضافة أنماط نصوص جديدة**
```dart
// في AppTextStyles
static TextStyle get customStyle => const TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
  fontFamily: primaryFont,
);
```

### 3. **إضافة مسافات جديدة**
```dart
// في AppSpacing
static const double customSpacing = 25.0;
static const EdgeInsets customPadding = EdgeInsets.all(customSpacing);
```

## 📱 المزايا

- ✅ **إدارة مركزية**: جميع الألوان والأنماط في مكان واحد
- ✅ **دعم الثيمات**: ثيمات فاتحة وداكنة مع اكتشاف تلقائي
- ✅ **قابلية إعادة الاستخدام**: يمكن استخدامه في جميع التطبيقات
- ✅ **سهولة التخصيص**: إضافة ألوان وأنماط جديدة بسهولة
- ✅ **أداء محسن**: استخدام ثوابت بدلاً من إنشاء كائنات جديدة
- ✅ **توثيق شامل**: تعليقات مفصلة لكل مكون
- ✅ **معايير التصميم**: اتباع معايير Material Design 3

## 🔄 التحديثات المستقبلية

- [ ] دعم الثيمات المخصصة حسب المستخدم
- [ ] إضافة المزيد من أنماط الألوان
- [ ] دعم الرسوم المتحركة في الثيمات
- [ ] إضافة أدوات تحليل الثيمات
- [ ] دعم الثيمات الموسمية

## 📞 الدعم

للاستفسارات أو المساعدة، يرجى التواصل مع فريق التطوير. 
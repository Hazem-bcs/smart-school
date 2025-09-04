# Resource Feature - Student App

## نظرة عامة
تم تحديث ميزة الموارد لتطبيق مبادئ Clean Code و Clean Architecture مع دعم كامل للثيمات واللغة العربية، واستخدام الـ AppBar المخصص والألوان البنفسجية.

## التعديلات المطبقة

### 1. تطبيق Clean Architecture
- **Domain Layer**: Entities, Use Cases, Repositories
- **Data Layer**: Models, Data Sources, Repository Implementations  
- **Presentation Layer**: BLoC, UI Pages, Widgets

### 2. فصل الـ Widgets
تم إنشاء widgets منفصلة لتحسين قابلية القراءة والصيانة:

- `ResourceCard`: عرض بطاقة مورد واحد
- `ResourceEmptyStateWidget`: عرض حالة عدم وجود موارد
- `ResourceErrorStateWidget`: عرض حالة الخطأ
- `ResourceInitialStateWidget`: عرض الحالة الأولية
- `ResourceListWidget`: عرض قائمة الموارد

### 3. دعم الثيمات مع الـ AppBar المخصص
- دعم كامل للثيم الفاتح والداكن
- استخدام الـ AppBar المخصص من الثيم مع:
  - ارتفاع 100px
  - زوايا مدورة في الأسفل
  - ظلال وألوان ديناميكية
  - دعم الخط العربي (Cairo)
- تطبيق `AppColors` و `AppSpacing` و `AppTextStyles`

### 4. الألوان البنفسجية
- استخدام `AppColors.secondary` (البنفسجي) بدلاً من الأزرق
- استخدام `AppColors.darkAccentPurple` للثيم الداكن
- تطبيق الألوان البنفسجية على:
  - أزرار التحديث
  - عناوين الموارد
  - روابط الموارد
  - أيقونات فتح الروابط

### 5. اللغة العربية
- جميع النصوص باللغة العربية
- استخدام `AppStrings` لمركزية النصوص
- دعم الخط العربي (Cairo)

### 6. Loading Indicator المخصص
- استخدام `SmartSchoolLoading` من core package
- رسائل تحميل باللغة العربية
- أنواع مختلفة من التحميل (dots, pulse, wave, etc.)

## هيكل الملفات

```
lib/features/resource/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── use_cases/
├── data/
│   ├── data_sources/
│   ├── models/
│   └── repositories/
├── presentation/
│   ├── blocs/
│   ├── pages/
│   └── widgets/
└── README.md
```

## الميزات

- ✅ دعم الثيمات (فاتح/داكن)
- ✅ الـ AppBar المخصص مع التصميم
- ✅ الألوان البنفسجية
- ✅ اللغة العربية
- ✅ Clean Architecture
- ✅ Widgets منفصلة
- ✅ Loading Indicator مخصص
- ✅ Pull-to-refresh
- ✅ Error handling
- ✅ Responsive design

## الاستخدام

```dart
// في الصفحة الرئيسية
class ResourcesPage extends StatefulWidget {
  // ...
}

// استخدام BLoC
BlocBuilder<ResourceBloc, ResourceState>(
  builder: (context, state) {
    // بناء المحتوى حسب الحالة
  },
)
```

## التطوير المستقبلي

- إضافة تصفية وبحث في الموارد
- دعم تحميل الملفات
- إضافة تصنيفات للموارد
- دعم المفضلة
- إشعارات للموارد الجديدة

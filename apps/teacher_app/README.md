# Teacher App

A Flutter application for teachers to manage their classes, students, and educational activities.

## Project Structure

This project follows Clean Architecture principles with the following structure:

```
lib/
├── features/
│   ├── auth/
│   │   └── presentation/
│   │       ├── blocs/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       └── ui/
│   │           ├── pages/
│   │           │   └── login_page.dart
│   │           └── widgets/
│   ├── classes/
│   │   └── presentation/
│   │       ├── blocs/
│   │       │   ├── classes_bloc.dart
│   │       │   ├── classes_event.dart
│   │       │   └── classes_state.dart
│   │       └── ui/
│   │           ├── pages/
│   │           │   └── classes_page.dart
│   │           └── widgets/
│   ├── home/
│   │   └── presentation/
│   │       ├── blocs/
│   │       │   ├── home_bloc.dart
│   │       │   ├── home_event.dart
│   │       │   └── home_state.dart
│   │       └── ui/
│   │           ├── pages/
│   │           │   └── home_page.dart
│   │           └── widgets/
│   ├── settings/
│   │   └── presentation/
│   │       ├── blocs/
│   │       │   ├── settings_bloc.dart
│   │       │   ├── settings_event.dart
│   │       │   └── settings_state.dart
│   │       └── ui/
│   │           ├── pages/
│   │           │   └── settings_page.dart
│   │           └── widgets/
│   └── profile/
│       └── presentation/
│           ├── blocs/
│           │   ├── profile_bloc.dart
│           │   ├── profile_event.dart
│           │   └── profile_state.dart
│           └── ui/
│               ├── pages/
│               │   └── profile_page.dart
│               └── widgets/
├── blocs/
│   └── sensitive_connectivity/
│       ├── connectivity_bloc.dart
│       ├── connectivity_event.dart
│       └── connectivity_state.dart
├── widgets/
│   ├── connectivity_widget.dart
│   └── connectivity_toast.dart
├── presentation/
│   └── app.dart
├── injection_container.dart
└── main.dart
```

## Features

### Assignments

- إدارة وإنشاء وعرض الواجبات للمعلم.
- تعتمد الميزة على معمارية Clean Architecture:
  - **Presentation Layer**: تتضمن BLoC (AssignmentBloc) وصفحات/ودجتس تعرض قائمة الواجبات وتفاصيلها وتدعم البحث والتصفية.
  - **Domain Layer**: تحتوي على الكيانات (Assignment, AssignmentStatus) وحالات الاستخدام (GetAssignmentsUseCase, AddAssignmentUseCase) التي تمثل منطق العمل.
  - **Data Layer**: تشمل AssignmentRepository و AssignmentRemoteDataSource، حيث يتم جلب البيانات من الـ backend (أو mock مؤقتاً).
- التدفق:
  1. الواجهة ترسل حدث (LoadAssignments أو AddAssignment) إلى الـBloc.
  2. الـBloc يستدعي الـUseCase المناسب من الدومين.
  3. الـUseCase يستدعي الريبو، والذي يتواصل مع الـDataSource.
  4. الـDataSource يجلب البيانات من الـbackend (أو mock مؤقتاً).
  5. النتيجة تعود للـBloc ليتم تحديث الحالة في الواجهة.
- الاعتمادات تتم عبر getIt في injection_container.dart، ويمكن بسهولة اختبار أو تبديل أي طبقة.
- الكود منظم بالكامل وقابل للتوسعة والاختبار.

### 1. Authentication (Auth)
- Login functionality for teachers
- Form validation
- Error handling

### 2. Classes
- View list of classes taught by the teacher
- Class selection for detailed management
- Display class information (name, subject, student count)

### 3. Home
- Dashboard for selected class
- Quick statistics (students, attendance, assignments, announcements)
- Quick actions (take attendance, create assignment, post announcement)

### 4. Settings
- Notification preferences
- Dark mode toggle
- Language selection
- Auto-sync settings
- App information

### 5. Profile
- Teacher profile information
- Personal details (name, email, phone, subject, experience)
- Quick actions (edit profile, change password, logout)

### 6. Connectivity
- Network connectivity monitoring
- Automatic retry functionality
- Toast notifications for connection status

## Dependencies

- **flutter_bloc**: State management
- **equatable**: Value equality
- **get_it**: Dependency injection
- **dio**: HTTP client
- **shared_preferences**: Local storage
- **easy_localization**: Internationalization
- **sizer**: Responsive UI
- **connectivity_plus**: Network connectivity

## Getting Started

1. Ensure you have Flutter installed
2. Run `flutter pub get` to install dependencies
3. Run `flutter analyze` to check for issues
4. Run `flutter run` to start the application

## Architecture

This project follows Clean Architecture with:

- **Presentation Layer**: UI components, BLoCs, pages, and widgets
- **Domain Layer**: Business logic, entities, and use cases (to be implemented)
- **Data Layer**: Repositories, data sources, and models (to be implemented)

## TODO

- [ ] Implement domain layer (entities, use cases)
- [ ] Implement data layer (repositories, data sources)
- [ ] Add navigation between pages
- [ ] Implement actual API integration
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Implement offline functionality
- [ ] Add push notifications
- [ ] Implement file upload for assignments
- [ ] Add student management features

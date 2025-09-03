part of 'dues_bloc.dart';

@immutable
sealed class DuesState {}

/// الحالة الأولية
final class DuesInitial extends DuesState {}

/// حالة تحميل البيانات
final class DuesDataLoadingState extends DuesState {}

/// حالة تحميل البيانات بنجاح
final class DuesDataLoadedState extends DuesState {
  final List<DueEntity> dueList;

  DuesDataLoadedState({required this.dueList});
}

/// حالة حدوث خطأ
final class DuesErrorState extends DuesState {
  final String message;

  DuesErrorState({required this.message});
}



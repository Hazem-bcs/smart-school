part of 'dues_bloc.dart';

@immutable
sealed class DuesEvent {}

/// حدث جلب قائمة المستحقات
class GetDuesListEvent extends DuesEvent {}

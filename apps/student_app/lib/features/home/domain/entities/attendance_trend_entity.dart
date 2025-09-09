import 'package:equatable/equatable.dart';

class AttendanceTrendEntity extends Equatable {
  final DateTime startDate; // بداية 7 أيام
  final List<int> codes; // 0 عطلة, 1 غياب, 2 حضور

  const AttendanceTrendEntity({
    required this.startDate,
    required this.codes,
  });

  @override
  List<Object?> get props => [startDate, codes];
}

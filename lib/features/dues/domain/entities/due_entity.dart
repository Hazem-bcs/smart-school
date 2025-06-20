
class DueEntity {
  final String id;
  final String description;
  final double amount;
  final DateTime dueDate;
  final bool isPaid;
  const DueEntity({
    required this.id,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.isPaid,
  });

  final String currency = 'ل.س';
}

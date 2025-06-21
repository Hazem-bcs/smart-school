import 'package:smart_school/widgets/app_exports.dart';
import 'package:flutter/material.dart';
import 'package:smart_school/features/dues/domain/entities/due_entity.dart';
import 'package:intl/intl.dart';

class DueCard extends StatefulWidget {
  final DueEntity dueEntity;

  const DueCard({
    super.key,
    required this.dueEntity,
  });

  @override
  State<DueCard> createState() => _DueCardState();
}

class _DueCardState extends State<DueCard> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMMM');
    final formattedDate = dateFormat.format(widget.dueEntity.dueDate);

    final String currency = widget.dueEntity.currency; // استخدام العملة من DueEntity

    // ** افتراض قيم لـ totalAmount و paidAmount لأنها غير موجودة في DueEntity **
    // هذا يسمح للـ UI بالعمل دون تعديل DueEntity.
    // إذا كنت تحتاج هذه القيم بدقة، يجب أن تأتي من الـ DueEntity أو من مكان آخر في طبقة البيانات.
    final double totalAmount = widget.dueEntity.amount;
    final double paidAmount = widget.dueEntity.isPaid ? widget.dueEntity.amount : 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: const Color(0xFFE0EAFC),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _toggleExpansion,
                  child: Column(
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.red,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.dueEntity.description,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: widget.dueEntity.isPaid ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              widget.dueEntity.isPaid ? 'Paid' : 'Unpaid',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '${widget.dueEntity.amount.toStringAsFixed(2)} $currency',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Divider(color: Colors.black26, height: 1),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${totalAmount.toStringAsFixed(2)} $currency',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        ':الرسم الإجمالي',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${paidAmount.toStringAsFixed(2)} $currency',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        ':الرسم المدفوع',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
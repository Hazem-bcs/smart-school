import 'package:dues/domain/entities/due_entity.dart';
import 'package:smart_school/widgets/app_exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:core/theme/index.dart'; // Import to access theme data
import 'package:core/theme/constants/app_colors.dart'; // Import to access custom colors
import '../../../../widgets/modern_design/modern_effects.dart';

class DueCard extends StatefulWidget {
  final DueEntity dueEntity;

  const DueCard({
    super.key,
    required this.dueEntity,
  });

  @override
  State<DueCard> createState() => _DueCardState();
}

class _DueCardState extends State<DueCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final dateFormat = DateFormat('d MMMM');
    final formattedDate = dateFormat.format(widget.dueEntity.dueDate);
    final String currency = widget.dueEntity.currency;
    final double totalAmount = widget.dueEntity.amount;
    final double paidAmount = widget.dueEntity.isPaid ? widget.dueEntity.amount : 0.0;

    final Color statusColor = widget.dueEntity.isPaid
        ? (isDark ? AppColors.darkSuccess : AppColors.success)
        : (isDark ? AppColors.darkDestructive : AppColors.error);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: ModernEffects.modernShadow(isDark: isDark, type: ShadowType.soft),
      ),
      child: Column(
        children: [
          // Main Card Content
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date and Expansion Icon
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formattedDate,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20.0),
                  // Details: Amount, Status, and Description (RTL layout)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.dueEntity.description,
                          textAlign: TextAlign.right,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                widget.dueEntity.isPaid ? 'مدفوع' : 'غير مدفوع',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '${widget.dueEntity.amount.toStringAsFixed(2)} $currency',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.titleLarge?.color,
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
          ),

          // Expanded Details
          SizeTransition(
            sizeFactor: _animation,
            axisAlignment: -1.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Divider(color: Colors.black26, height: 1),
                  const SizedBox(height: 10.0),
                  _buildDetailRow(
                    context,
                    'الرسم الإجمالي',
                    '${totalAmount.toStringAsFixed(2)} $currency',
                  ),
                  const SizedBox(height: 5.0),
                  _buildDetailRow(
                    context,
                    'الرسم المدفوع',
                    '${paidAmount.toStringAsFixed(2)} $currency',
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          ':$label',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.hintColor,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

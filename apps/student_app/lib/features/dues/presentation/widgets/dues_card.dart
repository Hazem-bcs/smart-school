import 'package:dues/domain/entities/due_entity.dart';
import 'package:smart_school/widgets/app_exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:core/theme/index.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';
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

    final dateFormat = DateFormat('d MMMM', 'ar');
    final formattedDate = dateFormat.format(widget.dueEntity.dueDate);
    final String currency = widget.dueEntity.currency;
    final double totalAmount = widget.dueEntity.amount;
    final double paidAmount = widget.dueEntity.isPaid ? widget.dueEntity.amount : 0.0;

    final Color statusColor = widget.dueEntity.isPaid
        ? (isDark ? AppColors.darkSuccess : AppColors.success)
        : (isDark ? AppColors.darkDestructive : AppColors.error);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppSpacing.baseBorderRadius,
        boxShadow: ModernEffects.modernShadow(isDark: isDark, type: ShadowType.soft),
      ),
      child: Column(
        children: [
          // Main Card Content
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: AppSpacing.baseBorderRadius,
            child: Padding(
              padding: AppSpacing.basePadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date and Expansion Icon
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formattedDate,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: theme.colorScheme.primary,
                          size: AppSpacing.baseIcon,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  // Details: Amount, Status, and Description (RTL layout)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.dueEntity.description,
                          textAlign: TextAlign.right,
                          style: AppTextStyles.h4.copyWith(
                            color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.base, 
                                vertical: AppSpacing.xs
                              ),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: AppSpacing.circularBorderRadius,
                              ),
                              child: Text(
                                widget.dueEntity.isPaid ? 'مدفوع' : 'غير مدفوع',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '${widget.dueEntity.amount.toStringAsFixed(2)} $currency',
                              style: AppTextStyles.h2.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base, 
                vertical: AppSpacing.sm
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Divider(
                    color: isDark ? AppColors.darkDivider : AppColors.gray200,
                    height: 1,
                  ),
                  const SizedBox(height: AppSpacing.base),
                  _buildDetailRow(
                    context,
                    'الرسم الإجمالي',
                    '${totalAmount.toStringAsFixed(2)} $currency',
                    isDark,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _buildDetailRow(
                    context,
                    'الرسم المدفوع',
                    '${paidAmount.toStringAsFixed(2)} $currency',
                    isDark,
                  ),
                  const SizedBox(height: AppSpacing.base),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          ':$label',
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

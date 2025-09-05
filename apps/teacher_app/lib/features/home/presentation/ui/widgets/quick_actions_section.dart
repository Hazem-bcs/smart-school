import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';
import 'quick_action_button.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback onCreateAssignment;
  final VoidCallback onScheduleZoom;
  final VoidCallback? onViewScheduledMeetings;

  const QuickActionsSection({
    super.key,
    required this.onCreateAssignment,
    required this.onScheduleZoom,
    this.onViewScheduledMeetings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
          child: Text(
            'إجراءات سريعة',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
          ),
          child: ResponsiveLayout(
            mobile: Column(
              children: [
                QuickActionButton(
                  text: 'إنشاء واجب',
                  onPressed: onCreateAssignment,
                  isPrimary: true,
                  icon: Icons.add,
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context)),
                QuickActionButton(
                  text: 'جدولة جلسة زوم',
                  onPressed: onScheduleZoom,
                  isPrimary: false,
                  icon: Icons.video_call,
                ),
                if (onViewScheduledMeetings != null) ...[
                  SizedBox(height: ResponsiveHelper.getSpacing(context)),
                  QuickActionButton(
                    text: 'الاجتماعات المجدولة',
                    onPressed: onViewScheduledMeetings,
                    isPrimary: false,
                    icon: Icons.list_alt,
                  ),
                ],
              ],
            ),
            tablet: Row(
              children: [
                Expanded(
                  child: QuickActionButton(
                    text: 'إنشاء واجب',
                    onPressed: onCreateAssignment,
                    isPrimary: true,
                    icon: Icons.add,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context)),
                Expanded(
                  child: QuickActionButton(
                    text: 'جدولة جلسة زوم',
                    onPressed: onScheduleZoom,
                    isPrimary: false,
                    icon: Icons.video_call,
                  ),
                ),
                if (onViewScheduledMeetings != null) ...[
                  SizedBox(width: ResponsiveHelper.getSpacing(context)),
                  Expanded(
                    child: QuickActionButton(
                      text: 'الاجتماعات المجدولة',
                      onPressed: onViewScheduledMeetings,
                      isPrimary: false,
                      icon: Icons.list_alt,
                    ),
                  ),
                ],
              ],
            ),
            desktop: Row(
              children: [
                Expanded(
                  child: QuickActionButton(
                    text: 'إنشاء واجب',
                    onPressed: onCreateAssignment,
                    isPrimary: true,
                    icon: Icons.add,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context)),
                Expanded(
                  child: QuickActionButton(
                    text: 'جدولة جلسة زوم',
                    onPressed: onScheduleZoom,
                    isPrimary: false,
                    icon: Icons.video_call,
                  ),
                ),
                if (onViewScheduledMeetings != null) ...[
                  SizedBox(width: ResponsiveHelper.getSpacing(context)),
                  Expanded(
                    child: QuickActionButton(
                      text: 'الاجتماعات المجدولة',
                      onPressed: onViewScheduledMeetings,
                      isPrimary: false,
                      icon: Icons.list_alt,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}



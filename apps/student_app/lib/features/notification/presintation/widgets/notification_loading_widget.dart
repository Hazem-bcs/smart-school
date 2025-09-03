import 'package:flutter/material.dart';
import 'package:core/widgets/unified_loading_indicator.dart';
import 'package:core/theme/constants/app_strings.dart';

/// Widget for displaying loading state in notification page
class NotificationLoadingWidget extends StatelessWidget {
  const NotificationLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SmartSchoolLoading(
      message: AppStrings.loadingNotifications,
      type: LoadingType.dots,
    );
  }
}

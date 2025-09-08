import 'package:flutter/material.dart';
import 'package:core/widgets/index.dart';

/// Widget لحالة التحميل في صفحة المستحقات
class DuesLoadingWidget extends StatelessWidget {
  const DuesLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SmartSchoolLoading(
      message: 'جاري تحميل المستحقات...',
      type: LoadingType.dots,
    );
  }
}

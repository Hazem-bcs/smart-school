import 'package:flutter/material.dart';
import 'package:core/widgets/unified_loading_indicator.dart';

class ProfileLoadingWidget extends StatelessWidget {
  const ProfileLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SmartSchoolLoading(
      message: 'جاري تحميل البيانات...',
      type: LoadingType.primary,
    );
  }
}

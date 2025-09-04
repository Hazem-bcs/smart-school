import 'package:flutter/material.dart';
import 'package:resource/domain/entities/resource_entity.dart';
import 'package:core/theme/constants/app_spacing.dart';
import 'resource_card.dart';

/// Widget لعرض قائمة الموارد
class ResourceListWidget extends StatelessWidget {
  final List<ResourceEntity> resources;
  final VoidCallback? onRefresh;

  const ResourceListWidget({
    super.key,
    required this.resources,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh?.call();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        padding: AppSpacing.screenPadding,
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final resource = resources[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == resources.length - 1 ? 0 : AppSpacing.sm,
            ),
            child: ResourceCard(resource: resource),
          );
        },
      ),
    );
  }
}

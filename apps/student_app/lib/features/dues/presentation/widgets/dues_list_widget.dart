import 'package:flutter/material.dart';
import 'package:dues/domain/entities/due_entity.dart';
import 'package:core/theme/index.dart';
import 'dues_card.dart';

/// Widget لقائمة المستحقات
class DuesListWidget extends StatelessWidget {
  final List<DueEntity> duesList;
  final VoidCallback onRefresh;

  const DuesListWidget({
    super.key,
    required this.duesList,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: theme.colorScheme.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: duesList.length,
        itemBuilder: (context, index) {
          return DueCard(dueEntity: duesList[index]);
        },
      ),
    );
  }
}

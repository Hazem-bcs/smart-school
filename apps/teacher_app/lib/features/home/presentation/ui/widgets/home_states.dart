import 'package:flutter/material.dart';

class HomeLoadingWidget extends StatelessWidget {
  const HomeLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class HomeErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const HomeErrorWidget({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

class HomeEmptyWidget extends StatelessWidget {
  const HomeEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text('لا توجد بيانات متاحة حالياً', style: theme.textTheme.titleMedium),
    );
  }
}



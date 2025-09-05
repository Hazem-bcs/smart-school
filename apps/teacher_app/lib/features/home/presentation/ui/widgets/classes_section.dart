import 'package:flutter/material.dart';
import '../../../domain/entities/class_entity.dart';
import 'class_card.dart';

class ClassesSection extends StatelessWidget {
  final List<ClassEntity> classes;
  final VoidCallback? onClassTap;

  const ClassesSection({
    super.key,
    required this.classes,
    this.onClassTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'الفصول',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classItem = classes[index];
              return ClassCard(
                title: classItem.title,
                imageUrl: classItem.imageUrl,
                index: index,
                onTap: onClassTap,
              );
            },
          ),
        ),
      ],
    );
  }
} 
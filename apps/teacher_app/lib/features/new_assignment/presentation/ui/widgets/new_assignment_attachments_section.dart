import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'section_title.dart';
import 'decorated_section_container.dart';
import 'action_tile.dart';

class NewAssignmentAttachmentsSection extends StatelessWidget {
  final bool isDark;
  final VoidCallback onAddFromDrive;
  final VoidCallback onUploadFile;
  const NewAssignmentAttachmentsSection({Key? key, required this.isDark, required this.onAddFromDrive, required this.onUploadFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'المرفقات', icon: Icons.attach_file, iconColor: isDark ? AppColors.info : AppColors.info),
        DecoratedSectionContainer(
          isDark: isDark,
          child: Column(
            children: [
              ActionTile(
                icon: Icons.cloud_download,
                text: 'إضافة من Drive',
                onTap: onAddFromDrive,
                iconColor: isDark ? AppColors.info : AppColors.info,
              ),
              ActionTile(
                icon: Icons.upload_file,
                text: 'رفع ملف',
                onTap: onUploadFile,
                iconColor: isDark ? AppColors.success : AppColors.success,
              ),
            ],
          ),
        ),
      ],
    );
  }
} 
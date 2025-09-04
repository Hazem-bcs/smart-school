import 'package:flutter/material.dart';
import 'package:resource/domain/entities/resource_entity.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_spacing.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget لعرض بطاقة مورد واحد
class ResourceCard extends StatelessWidget {
  final ResourceEntity resource;

  const ResourceCard({
    super.key,
    required this.resource,
  });

  /// فتح رابط المورد
  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(resource.url);
    if (!await launchUrl(uri)) {
      throw Exception('لا يمكن فتح الرابط: ${resource.url}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      margin: AppSpacing.smMargin,
      elevation: AppSpacing.smElevation,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.baseBorderRadius,
      ),
      color: isDark ? AppColors.darkCardBackground : AppColors.lightSurface,
      child: InkWell(
        onTap: _launchUrl,
        borderRadius: AppSpacing.baseBorderRadius,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان المورد
              Text(
                resource.title,
                style: AppTextStyles.h4.copyWith(
                  color: isDark ? AppColors.darkPrimaryText : AppColors.secondary,
                  fontWeight: AppTextStyles.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              
              // وصف المورد
              Text(
                resource.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkSecondaryText : AppColors.gray700,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),
              
              // رابط المورد
              Row(
                children: [
                  Icon(
                    Icons.link,
                    color: isDark ? AppColors.darkAccentPurple : AppColors.info,
                    size: AppSpacing.smIcon,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      resource.url,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark ? AppColors.darkAccentPurple : AppColors.info,
                        decoration: TextDecoration.underline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: Icon(
                      Icons.open_in_new,
                      color: isDark ? AppColors.darkAccentPurple : AppColors.secondary,
                    ),
                    onPressed: _launchUrl,
                    tooltip: AppStrings.openLink,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              
              // معلومات إضافية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.byTeacher.replaceAll('%s', resource.teacherId),
                    style: AppTextStyles.caption.copyWith(
                      color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                    ),
                  ),
                  Text(
                    '${resource.createdAt.day}/${resource.createdAt.month}/${resource.createdAt.year}',
                    style: AppTextStyles.caption.copyWith(
                      color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                    ),
                  ),
                ],
              ),
              
              // الفصول المستهدفة
              if (resource.targetClasses.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  AppStrings.targetClasses.replaceAll('%s', resource.targetClasses.join(', ')),
                  style: AppTextStyles.caption.copyWith(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

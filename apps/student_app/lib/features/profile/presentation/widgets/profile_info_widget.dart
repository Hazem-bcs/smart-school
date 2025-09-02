import 'package:flutter/material.dart';
import 'package:core/domain/entities/user_entity.dart';

class ProfileInfoWidget extends StatelessWidget {
  final UserEntity user;

  const ProfileInfoWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'المعلومات الشخصية',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),

          // Personal Information Cards
          _buildInfoCard(
            context,
            theme: theme,
            icon: Icons.email,
            title: 'البريد الإلكتروني',
            subtitle: user.email,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),

          _buildInfoCard(
            context,
            theme: theme,
            icon: Icons.phone,
            title: 'رقم الهاتف',
            subtitle: user.phone ?? 'غير محدد',
            color: theme.colorScheme.tertiary, // استخدام لون ثالث من الثيم
          ),
          const SizedBox(height: 12),

          _buildInfoCard(
            context,
            theme: theme,
            icon: Icons.location_on,
            title: 'العنوان',
            subtitle: user.address ?? 'غير محدد',
            color: theme.colorScheme.secondary, // استخدام لون ثانوي من الثيم
          ),
          const SizedBox(height: 12),

          _buildInfoCard(
            context,
            theme: theme,
            icon: Icons.cake,
            title: 'تاريخ الميلاد',
            subtitle: _formatDate(user.dateBirth),
            color: theme.colorScheme.onBackground, // استخدام لون مناسب
          ),
          const SizedBox(height: 20),

          // Family Information Section
          Text(
            'معلومات العائلة',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),

          _buildInfoCard(
            context,
            theme: theme,
            icon: Icons.person,
            title: 'اسم الأب',
            subtitle: user.fatherName ?? 'غير محدد',
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 12),

          _buildInfoCard(
            context,
            theme: theme,
            icon: Icons.person,
            title: 'اسم الأم',
            subtitle: user.motherName ?? 'غير محدد',
            color: theme.colorScheme.inversePrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, {
        required ThemeData theme,
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.hintColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'غير محدد';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

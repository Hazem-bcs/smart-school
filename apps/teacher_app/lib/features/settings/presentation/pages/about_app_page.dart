import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:core/theme/index.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'about.title'.tr(),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          _buildAppInfoCard(context),
          const SizedBox(height: AppSpacing.xl),
          _buildAppDetailsCard(context),
          const SizedBox(height: AppSpacing.xl),
          _buildContactCard(context),
        ],
      ),
    );
  }

  Widget _buildAppInfoCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: AppSpacing.smElevation,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.baseBorderRadius,
      ),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.school,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'about.app_name'.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'about.app_version'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'about.app_description'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppDetailsCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: AppSpacing.smElevation,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.baseBorderRadius,
      ),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'about.app_details'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildDetailItem(
              context,
              Icons.person,
              'about.developer'.tr(),
              'about.developer_name'.tr(),
            ),
            _buildDetailItem(
              context,
              Icons.email,
              'about.email'.tr(),
              'about.developer_email'.tr(),
            ),
            _buildDetailItem(
              context,
              Icons.web,
              'about.website'.tr(),
              'about.website_url'.tr(),
            ),
            _buildDetailItem(
              context,
              Icons.copyright,
              'about.copyright'.tr(),
              'about.copyright_text'.tr(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: AppSpacing.smElevation,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.baseBorderRadius,
      ),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'about.contact_us'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildContactItem(
              context,
              Icons.support_agent,
              'about.support'.tr(),
              'about.support_description'.tr(),
              () => _launchSupport(context),
            ),
            _buildContactItem(
              context,
              Icons.feedback,
              'about.feedback'.tr(),
              'about.feedback_description'.tr(),
              () => _launchFeedback(context),
            ),
            _buildContactItem(
              context,
              Icons.bug_report,
              'about.report_bug'.tr(),
              'about.report_bug_description'.tr(),
              () => _reportBug(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.base),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: AppSpacing.baseIcon,
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.baseBorderRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.base,
          horizontal: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: AppSpacing.baseIcon,
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.secondary,
              size: AppSpacing.smIcon,
            ),
          ],
        ),
      ),
    );
  }

  void _launchSupport(BuildContext context) {
    // TODO: Implement support launch
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('about.support_launched'.tr()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _launchFeedback(BuildContext context) {
    // TODO: Implement feedback launch
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('about.feedback_launched'.tr()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _reportBug(BuildContext context) {
    // TODO: Implement bug report
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('about.bug_report_launched'.tr()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
} 
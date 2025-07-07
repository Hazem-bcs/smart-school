import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:core/theme/index.dart';

class HelpFaqPage extends StatefulWidget {
  const HelpFaqPage({super.key});

  @override
  State<HelpFaqPage> createState() => _HelpFaqPageState();
}

class _HelpFaqPageState extends State<HelpFaqPage> {
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'help.faq_1_question'.tr(),
      answer: 'help.faq_1_answer'.tr(),
    ),
    FAQItem(
      question: 'help.faq_2_question'.tr(),
      answer: 'help.faq_2_answer'.tr(),
    ),
    FAQItem(
      question: 'help.faq_3_question'.tr(),
      answer: 'help.faq_3_answer'.tr(),
    ),
    FAQItem(
      question: 'help.faq_4_question'.tr(),
      answer: 'help.faq_4_answer'.tr(),
    ),
    FAQItem(
      question: 'help.faq_5_question'.tr(),
      answer: 'help.faq_5_answer'.tr(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'help.title'.tr(),
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

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          _buildHelpHeader(),
          const SizedBox(height: AppSpacing.xl),
          _buildQuickActions(),
          const SizedBox(height: AppSpacing.xl),
          _buildFaqSection(),
        ],
      ),
    );
  }

  Widget _buildHelpHeader() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: AppSpacing.smElevation,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.baseBorderRadius,
      ),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.help_outline,
                size: AppSpacing.lgIcon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'help.need_help'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'help.help_description'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
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

  Widget _buildQuickActions() {
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
              'help.quick_actions'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildQuickActionItem(
              Icons.video_library,
              'help.video_tutorials'.tr(),
              'help.video_tutorials_description'.tr(),
              () => _launchVideoTutorials(),
            ),
            _buildQuickActionItem(
              Icons.book,
              'help.user_guide'.tr(),
              'help.user_guide_description'.tr(),
              () => _launchUserGuide(),
            ),
            _buildQuickActionItem(
              Icons.support_agent,
              'help.contact_support'.tr(),
              'help.contact_support_description'.tr(),
              () => _contactSupport(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
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
              'help.frequently_asked_questions'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ..._faqItems.map((faq) => _buildFaqItem(faq)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
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

  Widget _buildFaqItem(FAQItem faq) {
    return ExpansionTile(
      title: Text(
        faq.question,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: AppTextStyles.medium,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            0,
            AppSpacing.xl,
            AppSpacing.base,
          ),
          child: Text(
            faq.answer,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
      iconColor: Theme.of(context).colorScheme.primary,
      collapsedIconColor: Theme.of(context).colorScheme.secondary,
    );
  }

  void _launchVideoTutorials() {
    // TODO: Implement video tutorials launch
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('help.video_tutorials_launched'.tr()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _launchUserGuide() {
    // TODO: Implement user guide launch
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('help.user_guide_launched'.tr()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _contactSupport() {
    // TODO: Implement contact support
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('help.contact_support_launched'.tr()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
} 
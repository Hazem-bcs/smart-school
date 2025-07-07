import 'package:flutter/material.dart';
import 'index.dart';

/// Example widget demonstrating the usage of the Smart School theme system
/// This file shows practical examples of how to use AppColors, AppTextStyles, and AppSpacing
class ThemeExample extends StatelessWidget {
  const ThemeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Theme System Example',
          style: AppTextStyles.h4.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Colors Example'),
            _buildColorsExample(),
            
            const SizedBox(height: AppSpacing.xl2),
            
            _buildSectionTitle('Text Styles Example'),
            _buildTextStylesExample(),
            
            const SizedBox(height: AppSpacing.xl2),
            
            _buildSectionTitle('Spacing Example'),
            _buildSpacingExample(),
            
            const SizedBox(height: AppSpacing.xl2),
            
            _buildSectionTitle('Theme-Aware Components'),
            _buildThemeAwareExample(context),
            
            const SizedBox(height: AppSpacing.xl2),
            
            _buildSectionTitle('Buttons Example'),
            _buildButtonsExample(context),
            
            const SizedBox(height: AppSpacing.xl2),
            
            _buildSectionTitle('Cards Example'),
            _buildCardsExample(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h3.copyWith(
        color: AppColors.primary,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }

  Widget _buildColorsExample() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _buildColorBox('Primary', AppColors.primary),
        _buildColorBox('Secondary', AppColors.secondary),
        _buildColorBox('Accent', AppColors.accent),
        _buildColorBox('Success', AppColors.success),
        _buildColorBox('Warning', AppColors.warning),
        _buildColorBox('Error', AppColors.error),
        _buildColorBox('Info', AppColors.info),
        _buildColorBox('Teacher', AppColors.teacherAccent),
        _buildColorBox('Student', AppColors.studentAccent),
        _buildColorBox('Parent', AppColors.parentAccent),
      ],
    );
  }

  Widget _buildColorBox(String label, Color color) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppSpacing.smBorderRadius,
        border: Border.all(color: AppColors.gray300),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.white,
            fontWeight: AppTextStyles.semiBold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTextStylesExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Heading 1', style: AppTextStyles.h1),
        const SizedBox(height: AppSpacing.sm),
        Text('Heading 2', style: AppTextStyles.h2),
        const SizedBox(height: AppSpacing.sm),
        Text('Heading 3', style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.sm),
        Text('Heading 4', style: AppTextStyles.h4),
        const SizedBox(height: AppSpacing.sm),
        Text('Heading 5', style: AppTextStyles.h5),
        const SizedBox(height: AppSpacing.md),
        Text('Body Large Text', style: AppTextStyles.bodyLarge),
        const SizedBox(height: AppSpacing.xs),
        Text('Body Medium Text', style: AppTextStyles.bodyMedium),
        const SizedBox(height: AppSpacing.xs),
        Text('Body Small Text', style: AppTextStyles.bodySmall),
        const SizedBox(height: AppSpacing.md),
        Text('Label Large', style: AppTextStyles.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        Text('Label Medium', style: AppTextStyles.labelMedium),
        const SizedBox(height: AppSpacing.xs),
        Text('Label Small', style: AppTextStyles.labelSmall),
        const SizedBox(height: AppSpacing.md),
        Text('Caption Text', style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildSpacingExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSpacingBox('XS (4px)', AppSpacing.xs),
        _buildSpacingBox('SM (8px)', AppSpacing.sm),
        _buildSpacingBox('MD (12px)', AppSpacing.md),
        _buildSpacingBox('Base (16px)', AppSpacing.base),
        _buildSpacingBox('LG (20px)', AppSpacing.lg),
        _buildSpacingBox('XL (24px)', AppSpacing.xl),
        _buildSpacingBox('XL2 (32px)', AppSpacing.xl2),
        _buildSpacingBox('XL3 (40px)', AppSpacing.xl3),
      ],
    );
  }

  Widget _buildSpacingBox(String label, double size) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: size,
            height: AppSpacing.base,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppSpacing.xsBorderRadius,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeAwareExample(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: AppSpacing.baseBorderRadius,
            border: Border.all(
              color: Theme.of(context).dividerTheme.color!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme-Aware Card',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'This card automatically adapts to the current theme (light/dark)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Icon(
              Icons.brightness_4,
              color: Theme.of(context).iconTheme.color,
              size: AppSpacing.baseIcon,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Current Theme: ${context.isDarkMode ? "Dark" : "Light"}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonsExample(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('Elevated Button'),
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(
          onPressed: () {},
          child: Text('Outlined Button'),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: () {},
          child: Text('Text Button'),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add, size: AppSpacing.smIcon),
                label: Text('Add'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit, size: AppSpacing.smIcon),
                label: Text('Edit'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardsExample(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Standard Card',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'This is a standard card with default styling',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          elevation: AppSpacing.mdElevation,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.lgBorderRadius,
          ),
          child: Padding(
            padding: AppSpacing.cardPaddingWide,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.warning,
                      size: AppSpacing.lgIcon,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Featured Card',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.warning,
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'This card has custom elevation and border radius',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Example of how to use the theme system in a real app
class ThemeUsageExample extends StatelessWidget {
  const ThemeUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme System Example',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const ThemeExample(),
    );
  }
} 
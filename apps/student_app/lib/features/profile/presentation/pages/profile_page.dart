import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_strings.dart';
import 'package:core/theme/constants/app_spacing.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';
import 'package:core/widgets/index.dart';
import '../bolcs/profile_bloc.dart';
import '../widgets/index.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileErrorState) {
          _showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBarWidget(
            title: AppStrings.profile,
            actions: [
              AppBarActions.refresh(
                onPressed: () {
                  context.read<ProfileBloc>().add(GetProfileDataEvent());
                },
                isDark: theme.brightness == Brightness.dark,
              ),
            ],
          ),
          body: ProfileBodyWidget(state: state),
        );
      },
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'Cairo',
          ),
        ),
        backgroundColor: isDark ? AppColors.darkDestructive : AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.baseBorderRadius,
        ),
        margin: AppSpacing.baseMargin,
      ),
    );
  }
}
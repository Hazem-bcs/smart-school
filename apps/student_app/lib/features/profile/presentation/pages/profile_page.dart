import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_strings.dart';
import '../bolcs/profile_bloc.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_info_widget.dart';
import '../widgets/profile_actions_widget.dart';

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
          ScaffoldMessenger.of(context).showSnackBar(
            ProfileErrorSnackBar(message: state.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: const ProfileAppBar(),
          body: ProfileBody(state: state),
        );
      },
    );
  }
}

// ---------------------- Widgets ----------------------

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        AppStrings.profile,
        style: theme.appBarTheme.titleTextStyle,
      ),
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: theme.appBarTheme.elevation,
      centerTitle: theme.appBarTheme.centerTitle,
      actions: [
        IconButton(
          onPressed: () {
            context.read<ProfileBloc>().add(GetProfileDataEvent());
          },
          icon: Icon(
            Icons.refresh,
            color: theme.appBarTheme.actionsIconTheme?.color,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ProfileBody extends StatelessWidget {
  final ProfileState state;
  const ProfileBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is GetDataLoadingState) {
      return const ProfileLoadingWidget();
    }

    if (state is ProfileDataLoadedState) {
      final userEntity = (state as ProfileDataLoadedState).userEntity;
      return ProfileLoadedWidget(userEntity: userEntity);
    }

    if (state is ProfileErrorState) {
      final message = (state as ProfileErrorState).message;
      return ProfileErrorWidget(message: message);
    }

    return const SizedBox.shrink();
  }
}

class ProfileLoadingWidget extends StatelessWidget {
  const ProfileLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'جاري تحميل البيانات...',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class ProfileLoadedWidget extends StatelessWidget {
  final dynamic userEntity;
  const ProfileLoadedWidget({super.key, required this.userEntity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(GetProfileDataEvent());
      },
      color: theme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            ProfileHeaderWidget(user: userEntity),
            ProfileInfoWidget(user: userEntity),
            ProfileActionsWidget(user: userEntity),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProfileErrorWidget extends StatelessWidget {
  final String message;
  const ProfileErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: theme.hintColor,
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ في تحميل البيانات',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ProfileBloc>().add(GetProfileDataEvent());
            },
            icon: Icon(Icons.refresh, color: theme.elevatedButtonTheme.style?.foregroundColor?.resolve({MaterialState.pressed})),
            label: Text('إعادة المحاولة', style: theme.elevatedButtonTheme.style?.textStyle?.resolve({MaterialState.pressed})),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.elevatedButtonTheme.style?.backgroundColor?.resolve({MaterialState.pressed}),
              foregroundColor: theme.elevatedButtonTheme.style?.foregroundColor?.resolve({MaterialState.pressed}),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileErrorSnackBar extends SnackBar {
  ProfileErrorSnackBar({super.key, required String message})
      : super(
    content: Text(message),
    backgroundColor: AppColors.error,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
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
          backgroundColor: Colors.grey[50],
          appBar: const ProfileAppBar(),
          body: ProfileBody(state: state),
        );
      },
    );
  }
}


// todo: here if we can refactor the code by separate the widgets into different files
/// ---------------------- Widgets ----------------------

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        AppStrings.profile,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            context.read<ProfileBloc>().add(GetProfileDataEvent());
          },
          icon: const Icon(
            Icons.refresh,
            color: Colors.white,
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          SizedBox(height: 16),
          Text(
            'جاري تحميل البيانات...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
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
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(GetProfileDataEvent());
      },
      color: AppColors.primary,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ في تحميل البيانات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ProfileBloc>().add(GetProfileDataEvent());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
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
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
}
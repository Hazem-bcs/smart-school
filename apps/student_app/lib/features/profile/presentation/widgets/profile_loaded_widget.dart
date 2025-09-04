import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/user_entity.dart';
import 'package:core/theme/constants/app_spacing.dart';
import '../bolcs/profile_bloc.dart';
import 'profile_header_widget.dart';
import 'profile_info_widget.dart';
import 'profile_actions_widget.dart';

class ProfileLoadedWidget extends StatelessWidget {
  final UserEntity userEntity;

  const ProfileLoadedWidget({
    super.key,
    required this.userEntity,
  });

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
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

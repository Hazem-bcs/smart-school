import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bolcs/profile_bloc.dart';
import 'profile_loading_widget.dart';
import 'profile_loaded_widget.dart';
import 'profile_error_widget.dart';

class ProfileBodyWidget extends StatelessWidget {
  final ProfileState state;

  const ProfileBodyWidget({
    super.key,
    required this.state,
  });

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
      return ProfileErrorWidget(
        message: message,
        onRetry: () {
          context.read<ProfileBloc>().add(GetProfileDataEvent());
        },
      );
    }

    return const SizedBox.shrink();
  }
}

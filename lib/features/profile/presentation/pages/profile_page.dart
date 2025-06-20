
import '../../../../widgets/app_exports.dart';
import '../bolcs/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state is GetDataLoadingState
              ? const CircularProgressIndicator()
              : state is ProfileDataLoadedState
              ? ListView(
            children: [
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(state.userEntity.profilePhotoUrl!),
              ),
              const SizedBox(height: 16),

              // Name
              ListTile(
                title: Text(state.userEntity.name!),
                leading: const Icon(Icons.person),
              ),
              const SizedBox(height: 16),

              // Email
              ListTile(
                title: Text(state.userEntity.email),
                leading: const Icon(Icons.email),
              ),
              const SizedBox(height: 16),

              //  email
              ListTile(
                title: Text(state.userEntity.email),
                leading: const Icon(Icons.phone),
              ),
              const SizedBox(height: 16),

              //! Address
              ListTile(
                // title: Text(state.userEntity.address['type']),
                leading: const Icon(Icons.location_city),
              ),
              const SizedBox(height: 16),
            ],
          )
              : Container(),
        );
      },
    );
  }
}

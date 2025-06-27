import 'package:core/theme/constants/app_strings.dart';
import 'package:core/theme/constants/colors.dart';
import 'package:smart_school/features/profile/presentation/pages/edit_profile_page.dart';

import '../../../../widgets/app_exports.dart';
import '../bolcs/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context.read<ProfileBloc>().add(GetProfileDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBarWidget(title: AppStrings.profile),
          body:
              state is GetDataLoadingState
                  ? const Center(child: CircularProgressIndicator())
                  : state is ProfileDataLoadedState
                  ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Profile Picture
                          AppAvatarWidget(
                            imageUrl : state.userEntity.profilePhotoUrl ??
                            "assets/images/img.png"      ,
                            radius: 70,
                          ),
                          const SizedBox(height: 15),
                          // User Name
                          Text(
                            "${state.userEntity.name}\nlevel" ,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),

                          // Information Cards
                          _buildInfoCard(
                            context,
                            icon: Icons.email,
                            title: 'Email',
                            subtitle: state.userEntity.email,
                          ),
                          const SizedBox(height: 15),
                          _buildInfoCard(
                            context,
                            icon: Icons.phone,
                            title: 'Phone',
                            subtitle: state.userEntity.email ?? 'N/A',
                          ),
                          const SizedBox(height: 15),
                          _buildInfoCard(
                            context,
                            icon: Icons.location_on,
                            title: 'Address',
                            subtitle:
                                state.userEntity.name ??
                                'N/A', // Assuming an address field
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditProfilePage(
                                        currentUser: state.userEntity,
                                      ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Profile'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : Container(), // Or a custom error widget
        );
      },
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Icon(icon, size: 28, color: primaryColor),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

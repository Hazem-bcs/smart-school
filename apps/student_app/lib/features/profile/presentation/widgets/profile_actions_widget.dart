import 'package:flutter/material.dart';
import 'package:core/domain/entities/user_entity.dart';
import 'package:core/theme/constants/app_colors.dart';
import '../pages/edit_profile_page.dart';

class ProfileActionsWidget extends StatelessWidget {
  final UserEntity user;

  const ProfileActionsWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Edit Profile Button
          Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(currentUser: user),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 24,
              ),
              label: const Text(
                'تعديل الملف الشخصي',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          
       ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/profile.dart';
import '../../theme/profile_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileHeader extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onEditProfile;

  const ProfileHeader({
    super.key,
    required this.profile,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          _buildAvatar(),
          
          const SizedBox(height: 16),
          
          // Name
          Text(
            profile.name,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Title
          Text(
            profile.bio,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Edit Profile Button
          _buildEditButton(context),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF6C63FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: ProfileTheme.primary.withOpacity(0.2),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: ProfileTheme.primary.withOpacity(0.13),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: profile.avatarUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF6C63FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.userAstronaut,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF6C63FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.userAstronaut,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onEditProfile,
      icon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF00B894).withOpacity(0.15),
        ),
        padding: const EdgeInsets.all(6),
        child: FaIcon(
          FontAwesomeIcons.userPen,
          size: 18,
          color: const Color(0xFF00B894),
        ),
      ),
      label: const Text('Edit Profile'),
      style: ProfileTheme.primaryButtonStyle(context),
    );
  }
} 
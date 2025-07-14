import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/profile.dart';
import '../../theme/profile_theme.dart';

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
            style: ProfileTheme.headline,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Title
          Text(
            profile.title,
            style: ProfileTheme.body.copyWith(color: ProfileTheme.primary),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 4),
          
          // Subtitle
          Text(
            profile.subtitle,
            style: ProfileTheme.caption,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Edit Profile Button
          _buildEditButton(),
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
        border: Border.all(
          color: ProfileTheme.primary.withOpacity(0.2),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: ProfileTheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: profile.avatarUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: ProfileTheme.background,
            child: Icon(
              Icons.person,
              size: 60,
              color: ProfileTheme.textSecondary,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: ProfileTheme.background,
            child: Icon(
              Icons.person,
              size: 60,
              color: ProfileTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton.icon(
      onPressed: onEditProfile,
      icon: const Icon(Icons.edit, size: 18),
      label: const Text('Edit Profile'),
      style: ProfileTheme.primaryButtonStyle,
    );
  }
} 
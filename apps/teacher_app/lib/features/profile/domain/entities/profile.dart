// Domain entities must not depend on data models.

class Profile {
  final String id;
  final String name;
  final String bio;
  final String avatarUrl;
  final ContactInfo contactInfo;
  final List<SocialMedia> socialMedia;
  final ProfessionalInfo professionalInfo;
  
  Profile({
    required this.id,
    required this.name,
    required this.bio,
    required this.avatarUrl,
    required this.contactInfo,
    required this.socialMedia,
    required this.professionalInfo,
  });

  // Mapping to models is handled in the repository layer
}

class ContactInfo {
  final String email;
  final String phone;

  ContactInfo({
    required this.email,
    required this.phone,
  });

  // Mapping to models is handled in the repository layer
}

class SocialMedia {
  final String platform;
  final String url;
  final String icon;

  SocialMedia({
    required this.platform,
    required this.url,
    required this.icon,
  });

  // Mapping to models is handled in the repository layer
}

class ProfessionalInfo {
  final List<String> subjectsTaught;
  final List<String> gradeLevels;
  final String department;
  final String qualifications;
  final String certifications;

  ProfessionalInfo({
    required this.subjectsTaught,
    required this.gradeLevels,
    required this.department,
    required this.qualifications,
    required this.certifications,
  });

  // Mapping to models is handled in the repository layer
} 
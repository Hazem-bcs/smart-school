class Profile {
  final String id;
  final String name;
  final String title;
  final String subtitle;
  final String avatarUrl;
  final ContactInfo contactInfo;
  final List<SocialMedia> socialMedia;
  final ProfessionalInfo professionalInfo;

  Profile({
    required this.id,
    required this.name,
    required this.title,
    required this.subtitle,
    required this.avatarUrl,
    required this.contactInfo,
    required this.socialMedia,
    required this.professionalInfo,
  });
}

class ContactInfo {
  final String email;
  final String phone;

  ContactInfo({
    required this.email,
    required this.phone,
  });
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
} 
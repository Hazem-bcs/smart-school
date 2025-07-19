import 'package:teacher_app/features/profile/data/models/profile_model.dart';

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

    ProfileModel toModel() {
    return ProfileModel(
      id: id,
      name: name,
      bio: bio,
      avatarUrl: avatarUrl,
      contactInfoModel: contactInfo.toModel(),
      socialMediaModel: socialMedia.map((sm) => sm.toModel()).toList(),
      professionalInfoModel: professionalInfo.toModel(),
    );
  }
}

class ContactInfo {
  final String email;
  final String phone;

  ContactInfo({
    required this.email,
    required this.phone,
  });

  ContactInfoModel toModel() {
    return ContactInfoModel(
      email: email,
      phone: phone,
    );
  }
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

  SocialMediaModel toModel() {
    return SocialMediaModel(
      platform: platform,
      url: url,
      icon: icon,
    );
  }
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

  ProfessionalInfoModel toModel() {
    return ProfessionalInfoModel(
      subjectsTaught: subjectsTaught,
      gradeLevels: gradeLevels,
      department: department,
      qualifications: qualifications,
      certifications: certifications,
    );
  }
} 
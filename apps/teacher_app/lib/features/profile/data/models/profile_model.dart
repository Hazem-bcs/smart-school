
import 'package:teacher_app/features/profile/domain/entities/profile.dart';

class ProfileModel {
  final String id;
  final String name;
  final String bio;
  final String avatarUrl;
  final ContactInfoModel contactInfoModel;
  final List<SocialMediaModel> socialMediaModel;
  final ProfessionalInfoModel professionalInfoModel;

  ProfileModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.avatarUrl,
    required this.contactInfoModel,
    required this.socialMediaModel,
    required this.professionalInfoModel,
  });

  Profile toEntity() {
    return Profile(
      id: id,
      name: name,
      bio: bio,
      avatarUrl: avatarUrl,
      contactInfo: contactInfoModel.toEntity(),
      socialMedia: socialMediaModel.map((e) => e.toEntity()).toList(),
      professionalInfo: professionalInfoModel.toEntity(),
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      contactInfoModel: ContactInfoModel.fromJson(json['contactInfo'] ?? {}),
      socialMediaModel: (json['socialMedia'] as List<dynamic>?)
          ?.map((item) => SocialMediaModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      professionalInfoModel: ProfessionalInfoModel.fromJson(json['professionalInfo'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'contactInfo': (contactInfoModel).toJson(),
      'socialMedia': socialMediaModel.map((item) => (item).toJson()).toList(),
      'professionalInfo': (professionalInfoModel).toJson(),
    };
  }
}

class ContactInfoModel {
  final String email;
  final String phone;

  ContactInfoModel({
    required this.email,
    required this.phone,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
    };
  }

  ContactInfo toEntity() {
    return ContactInfo(
      email: email,
      phone: phone,
    );
  }
}

class SocialMediaModel {
  final String platform;
  final String url;
  final String icon;

  SocialMediaModel({
    required this.platform,
    required this.url,
    required this.icon,
  });

  factory SocialMediaModel.fromJson(Map<String, dynamic> json) {
    return SocialMediaModel(
      platform: json['platform'] ?? '',
      url: json['url'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'url': url,
      'icon': icon,
    };
  }

  SocialMedia toEntity() {
    return SocialMedia(
      platform: platform,
      url: url,
      icon: icon,
    );
  }
}

class ProfessionalInfoModel {
  final List<String> subjectsTaught;
  final List<String> gradeLevels;
  final String department;
  final String qualifications;
  final String certifications;

  ProfessionalInfoModel({
    required this.subjectsTaught,
    required this.gradeLevels,
    required this.department,
    required this.qualifications,
    required this.certifications,
  });

  factory ProfessionalInfoModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalInfoModel(
      subjectsTaught: (json['subjectsTaught'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      gradeLevels: (json['gradeLevels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      department: json['department'] ?? '',
      qualifications: json['qualifications'] ?? '',
      certifications: json['certifications'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectsTaught': subjectsTaught,
      'gradeLevels': gradeLevels,
      'department': department,
      'qualifications': qualifications,
      'certifications': certifications,
    };
  }

  ProfessionalInfo toEntity() {
    return ProfessionalInfo(
      subjectsTaught: subjectsTaught,
      gradeLevels: gradeLevels,
      department: department,
      qualifications: qualifications,
      certifications: certifications,
    );
  }
}



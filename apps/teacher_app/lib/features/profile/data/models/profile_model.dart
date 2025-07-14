import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required super.id,
    required super.name,
    required super.title,
    required super.subtitle,
    required super.avatarUrl,
    required super.contactInfo,
    required super.socialMedia,
    required super.professionalInfo,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      contactInfo: ContactInfoModel.fromJson(json['contactInfo'] ?? {}),
      socialMedia: (json['socialMedia'] as List<dynamic>?)
          ?.map((item) => SocialMediaModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      professionalInfo: ProfessionalInfoModel.fromJson(json['professionalInfo'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'subtitle': subtitle,
      'avatarUrl': avatarUrl,
      'contactInfo': (contactInfo as ContactInfoModel).toJson(),
      'socialMedia': socialMedia.map((item) => (item as SocialMediaModel).toJson()).toList(),
      'professionalInfo': (professionalInfo as ProfessionalInfoModel).toJson(),
    };
  }
}

class ContactInfoModel extends ContactInfo {
  ContactInfoModel({
    required super.email,
    required super.phone,
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
}

class SocialMediaModel extends SocialMedia {
  SocialMediaModel({
    required super.platform,
    required super.url,
    required super.icon,
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
}

class ProfessionalInfoModel extends ProfessionalInfo {
  ProfessionalInfoModel({
    required super.subjectsTaught,
    required super.gradeLevels,
    required super.department,
    required super.qualifications,
    required super.certifications,
  });

  factory ProfessionalInfoModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalInfoModel(
      subjectsTaught: List<String>.from(json['subjectsTaught'] ?? []),
      gradeLevels: List<String>.from(json['gradeLevels'] ?? []),
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
} 
import '../../domain/entities/profile.dart';

class ProfileModel {
  final String id;
  final String name;
  final String title;
  final String subtitle;
  final String avatarUrl;
  final ContactInfoModel contactInfo;
  final List<SocialMediaModel> socialMedia;
  final ProfessionalInfoModel professionalInfo;

  ProfileModel({
    required this.id,
    required this.name,
    required this.title,
    required this.subtitle,
    required this.avatarUrl,
    required this.contactInfo,
    required this.socialMedia,
    required this.professionalInfo,
  });

  Profile toEntity() {
    return Profile(
      id: id,
      name: name,
      title: title,
      subtitle: subtitle,
      avatarUrl: avatarUrl,
      contactInfo: contactInfo.toEntity(),
      socialMedia: socialMedia.map((e) => e.toEntity()).toList(),
      professionalInfo: professionalInfo.toEntity(),
    );
  }

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
      'contactInfo': (contactInfo).toJson(),
      'socialMedia': socialMedia.map((item) => (item).toJson()).toList(),
      'professionalInfo': (professionalInfo).toJson(),
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



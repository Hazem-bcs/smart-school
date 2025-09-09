// Models should not depend on Entity classes – keep this file data-layer only

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

  // Mapping to entities is handled in the repository layer

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name_ar'] ?? '',
      bio: json['bio'] ?? '',
      avatarUrl: json['image_url'] ?? '',
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

  // Mapping to entities is handled in the repository layer
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

  // Mapping to entities is handled in the repository layer
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

  // Mapping to entities is handled in the repository layer
}
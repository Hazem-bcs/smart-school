import '../models/profile_model.dart';

class ProfileMockDataSource {
  static ProfileModel getMockProfile() {
    return ProfileModel(
      id: '1',
      name: 'Ms. Harper',
      title: 'Math Teacher • Verified Educator',
      subtitle: 'Joined 2021',
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCHzPO89rx1w89N6EGyFMWWe6KbgpBYOVSlJaQh7F-yjzN7LuOvw_GiMuifQLSjQWf_PF0-mq-FO6F7JF5oKnWhecJJAArdgGJlbCQHYjFnAKOLmusgmxkW_z8XBOhi2ChIWBhdF5wTkXnyJRL9S7oNiqDWdvbznaFaQ2coMb9U4Fy37k0Jjuo-zy-NVMusNFNHueEyxsFiKPMBMvF-HTfgZNokD3N5hlm4yY2xEFefrU8TT0M3eKYerKTZkVYhIZn_gTVSdhAfxSL9',
      contactInfo: ContactInfoModel(
        email: 'harper.math@school.edu',
        phone: '(555) 123-4567',
      ),
      socialMedia: [
        SocialMediaModel(
          platform: 'Twitter',
          url: 'https://twitter.com/username',
          icon: 'twitter',
        ),
        SocialMediaModel(
          platform: 'LinkedIn',
          url: 'https://linkedin.com/in/username',
          icon: 'linkedin',
        ),
      ],
      professionalInfo: ProfessionalInfoModel(
        subjectsTaught: ['Algebra', 'Geometry'],
        gradeLevels: ['9th', '10th Grade'],
        department: 'Mathematics Department',
        qualifications: 'M.Ed. in Mathematics',
        certifications: 'Certified Math Educator',
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/features/profile/presentation/blocs/profile_view_bloc.dart';
import 'package:teacher_app/features/profile/presentation/blocs/profile_view_event.dart';
import 'package:teacher_app/features/profile/presentation/blocs/profile_view_state.dart';
import '../../../domain/entities/profile.dart';
import '../widgets/profile_header.dart';
import '../widgets/info_card.dart';
import '../../theme/profile_theme.dart';
import '../../../../../core/routing/navigation_extension.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _pageAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _pageAnimationController.forward();

    // Load profile when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewBloc>().add(LoadProfile());
    });
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF181C2A)
          : theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: BlocBuilder<ProfileViewBloc, ProfileViewState>(
            builder: (context, state) {
              if (state is ProfileViewLoading) {
                return _buildLoadingState();
              } else if (state is ProfileViewLoaded) {
                return _buildLoadedState(state.profile);
              } else if (state is ProfileViewError) {
                return _buildErrorState(state.message);
              } else {
                return _buildInitialState();
              }
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: ProfileTheme.icon),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'الملف الشخصي',
      ),
      centerTitle: true,
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ProfileTheme.primary),
          ),
          SizedBox(height: 16),
          Text('جاري تحميل الملف الشخصي...'),
        ],
      ),
    );
  }

  Widget _buildLoadedState(Profile profile) {
    return RefreshIndicator(
      onRefresh: () async {
        // Trigger profile refresh
        context.read<ProfileViewBloc>().add(LoadProfile());
        // Wait a bit to show the refresh animation
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: ProfileTheme.primary,
      backgroundColor: Colors.white,
      strokeWidth: 3.0,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // رأس الملف الشخصي
            ProfileHeader(
              profile: profile,
              onEditProfile: () {
                context.goToEditProfile();
              },
            ),
            // إحصائيات سريعة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.book,
                      label: 'المواد',
                      value: profile.professionalInfo.subjectsTaught.length.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.people,
                      label: 'الفصول',
                      value: profile.professionalInfo.gradeLevels.length.toString(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            
            // بطاقة معلومات التواصل
            InfoCard(
              title: 'معلومات التواصل',
              items: [
                InfoCardItem(
                  icon: 'email',
                  primaryText: 'البريد الإلكتروني',
                  secondaryText: profile.contactInfo.email,
                  onTap: () => print(profile.contactInfo.email),
                ),
                InfoCardItem(
                  icon: 'phone',
                  primaryText: 'رقم الجوال',
                  secondaryText: profile.contactInfo.phone,
                  onTap: () {
                  },
                ),
              ],
            ),
            
            // بطاقة المعلومات المهنية
            InfoCard(
              title: 'المعلومات المهنية',
              items: [
                if (profile.professionalInfo.department.isNotEmpty)
                  InfoCardItem(
                    icon: 'building',
                    primaryText: 'القسم',
                    secondaryText: profile.professionalInfo.department,
                  ),
                if (profile.professionalInfo.qualifications.isNotEmpty)
                  InfoCardItem(
                    icon: 'graduation_cap',
                    primaryText: 'المؤهلات',
                    secondaryText: profile.professionalInfo.qualifications,
                  ),
                if (profile.professionalInfo.certifications.isNotEmpty)
                  InfoCardItem(
                    icon: 'certificate',
                    primaryText: 'الشهادات',
                    secondaryText: profile.professionalInfo.certifications,
                  ),
              ],
            ),
            
            // بطاقة المواد التي يدرسها
            if (profile.professionalInfo.subjectsTaught.isNotEmpty)
              InfoCard(
                title: 'المواد التي يدرسها',
                items: profile.professionalInfo.subjectsTaught
                    .map((s) => InfoCardItem(
                          icon: 'book_open',
                          primaryText: s,
                        ))
                    .toList(),
              ),
            
            // بطاقة الفصول/المستويات
            if (profile.professionalInfo.gradeLevels.isNotEmpty)
              InfoCard(
                title: 'الفصول الدراسية',
                items: profile.professionalInfo.gradeLevels
                    .map((g) => InfoCardItem(
                          icon: 'users',
                          primaryText: g,
                        ))
                    .toList(),
              ),
            
            // بطاقة وسائل التواصل الاجتماعي
            if (profile.socialMedia.isNotEmpty)
              InfoCard(
                title: 'وسائل التواصل الاجتماعي',
                items: profile.socialMedia.map((social) => InfoCardItem(
                  icon: social.icon,
                  primaryText: social.platform,
                  onTap: () {},
                )).toList(),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileViewBloc>().add(LoadProfile());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: ProfileTheme.primary,
      backgroundColor: Colors.white,
      strokeWidth: 3.0,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Text('حدث خطأ أثناء تحميل الملف الشخصي'),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProfileViewBloc>().add(LoadProfile());
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileViewBloc>().add(LoadProfile());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: ProfileTheme.primary,
      backgroundColor: Colors.white,
      strokeWidth: 3.0,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 200,
          child: const Center(
            child: Text(
              'مرحبًا بك في ملفك الشخصي\nاسحب للأسفل لتحميل البيانات',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ProfileTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: ProfileTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
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
                Text(
                  'Error loading profile',
                ),
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
                  child: const Text('Retry'),
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
              'Welcome to your profile\nPull down to load profile data',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc.dart';
import '../../../../../routing/navigation_extension.dart';
import '../../../../../core/responsive_widgets.dart';
import '../widgets/splash_content.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    print('🎬 SplashPage initState called');
    // التحقق من حالة المصادقة عند بدء الصفحة
    context.read<AuthBloc>().add(CheckAuthStatus());
    print('📤 CheckAuthStatus event sent');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print('🎯 SplashPage received state: ${state.runtimeType}');
        if (state is AuthAuthenticated) {
          print('🚀 Navigating to classes page');
          // إذا كان المستخدم مسجل الدخول، انتقل لصفحة الفصول
          context.goToHome(className: 'Default Class');
        } else if (state is AuthUnauthenticated) {
          print('🚀 Navigating to login page');
          // إذا لم يكن المستخدم مسجل الدخول، انتقل لصفحة تسجيل الدخول
          context.goToLogin();
        } else if (state is AuthError) {
          print('❌ Auth error: ${state.message}');
          // في حالة الخطأ، انتقل لصفحة تسجيل الدخول
          context.goToLogin();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: ResponsiveContent(
          child: Center(
            child: const SplashContent(),
          ),
        ),
      ),
    );
  }


} 
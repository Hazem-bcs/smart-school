import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import '../../blocs/auth_bloc.dart';
import '../../../../../routing/navigation_extension.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // التحقق من حالة المصادقة عند بدء الصفحة
    context.read<AuthBloc>().add(CheckAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // إذا كان المستخدم مسجل الدخول، انتقل لصفحة الفصول
          context.goToClasses();
        } else if (state is AuthUnauthenticated) {
          // إذا لم يكن المستخدم مسجل الدخول، انتقل لصفحة تسجيل الدخول
          context.goToLogin();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // مؤشر التحميل أو اللوجو
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    );
                  }
                  // في الحالات الأخرى، أظهر اللوجو
                  return Icon(
                    Icons.school,
                    size: 20.w,
                    color: Colors.white,
                  );
                },
              ),
              SizedBox(height: 4.h),
              Text(
                'app_title'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.w,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Teacher App',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 4.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/theme/constants/colors.dart';
import '../blocs/auth_bloc.dart';
import '../cuibts/on_boarding_cubit.dart';
import '../../../../generated/locale_keys.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthenticationStatusEvent());
  }


  Future<void> _navigateBasedOnBoarding() async {
    final bool hasSeenOnboarding = await context.read<OnboardingCubit>().checkOnboardingStatus();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          !hasSeenOnboarding ? '/onBoarding' :  '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // إذا كانت الحالة Authenticated، انتقل إلى home
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        } else if (state is Unauthenticated) {
          // إذا كانت الحالة Unauthenticated، تحقق من onboarding ثم انتقل
          _navigateBasedOnBoarding();
        }
      },
      child: Scaffold(
        body: Container(
          color: primaryColor,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // يمكن إظهار مؤشر تحميل بينما تكون الحالة AuthChecking
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthChecking) {
                      return CircularProgressIndicator(color: secondaryColor);
                    }
                    // في الحالات الأخرى، أظهر اللوجو
                    return Image.asset(
                      'assets/images/graduation-hat.png',
                      color: secondaryColor,
                      height: 300,
                    );
                  },
                ),
                const SizedBox(height: 40),
                Text(
                  LocaleKeys.stellar.tr(),
                  style: const TextStyle(color: secondaryColor, fontSize: 40),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/constants/app_colors.dart';

import '../cuibts/on_boarding_cubit.dart';
import '../widgets/onboarding_page_widget.dart';
import '../widgets/onboarding_navigation_button.dart';
import '../../../../generated/locale_keys.g.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            onPageChanged: (int index) {
              setState(() {
                currentPage = index;
              });
            },
            controller: pageController,
            children: [
              OnboardingPageWidget(
                title: LocaleKeys.on_boarding_title1.tr(),
                imagePath: 'assets/images/homework.png',
                backgroundColor: isDark 
                  ? AppColors.darkCardBackground 
                  : const Color(0xffFFE9D4), // lightOrange
                imageHeight: 420,
              ),
              OnboardingPageWidget(
                title: LocaleKeys.on_boarding_title2.tr(),
                imagePath: 'assets/images/attendance.png',
                backgroundColor: isDark 
                  ? AppColors.darkElevatedSurface 
                  : const Color(0xffAEC5EB), // lightBlue
                imageHeight: 450,
              ),
              OnboardingPageWidget(
                title: LocaleKeys.on_boarding_title3.tr(),
                imagePath: 'assets/images/exam.png',
                backgroundColor: isDark 
                  ? AppColors.darkSurface 
                  : const Color(0xffEDAFB8), // lightPink
                imageHeight: 400,
              ),
            ],
          ),
          OnboardingNavigationButton(
            isLastPage: currentPage == 2,
            onPressed: () async {
              if (currentPage == 2) {
                context.read<OnboardingCubit>().setOnboardingViewed();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
                return;
              }
              pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubicEmphasized,
              );
            },
          ),
        ],
      ),
    );
  }
}

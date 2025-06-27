import 'package:core/theme/constants/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cuibts/on_boarding_cubit.dart';
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
              Container(
                color: lightOrange,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          LocaleKeys.on_boarding_title1.tr() ,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Image.asset(
                        'assets/images/homework.png',
                        height: 420,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  color: lightBlue,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          LocaleKeys.on_boarding_title2.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Image.asset('assets/images/attendance.png', height: 450),
                    ],
                  ))),
              Container(
                  color: lightPink,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          LocaleKeys.on_boarding_title3.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Image.asset('assets/images/exam.png', height: 400),
                    ],
                  ))),
            ],
          ),
          Positioned(
            bottom: 40,
            child: InkWell(
              onTap: () async{
                if (currentPage == 2) {
                  context.read<OnboardingCubit>().setOnboardingViewed();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login',(route) => false,);
                  return;
                }
                pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutCubicEmphasized);
              },
              child: CircleAvatar(
                backgroundColor: primaryColor,
                radius: 30,
                child: Center(
                  child: Icon(
                      currentPage == 2 ? Icons.check : Icons.arrow_forward_ios , color: Colors.white,),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

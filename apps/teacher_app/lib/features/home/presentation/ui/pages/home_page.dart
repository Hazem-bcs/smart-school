import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/injection_container.dart';
import '../../blocs/home_bloc.dart';
import '../../blocs/home_event.dart';
import '../../blocs/home_state.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';
import '../../../../../core/widgets/shared_bottom_navigation.dart';
import '../widgets/home_states.dart';
import '../widgets/classes_section.dart';
import '../widgets/notifications_section.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/assignments_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        toolbarHeight: 55,
        title: Text(
          'لوحة التحكم',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/profile'),
            child: const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCwbuL0ZiDMlk21d_cKtbpty8WoXWwySyGPVjGH2-e69ZAKGbiQjraud70q83qALhpx_rFdwh2p3Y0sRc3D7CbjMYdDIdu8fl6SlYiGagcEu5D-0npFOrOSepq90hGqkpXcNeTLbYFZKTO4FDfR6LNKLoRL8MpA7KNHBpbxwjEFIz-oQrL-b0O9FXdHqvKxVNgfpt_21HRS4jKHncoQBHK_lSE9FulUBsR8n6xRMgauziyWJo9exGOKF1w2Rvz_3CZYGEnBeyke2cEZ',
              ),
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (_) => getIt<HomeBloc>()..add(const LoadHomeData()),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) return const HomeLoadingWidget();
            if (state is HomeError) {
              return HomeErrorWidget(
                message: state.message,
                onRetry: () => context.read<HomeBloc>().add(const RefreshHomeData()),
              );
            }
            if (state is HomeLoaded) {
              if (state.classes.isEmpty && state.notifications.isEmpty) {
                return const HomeEmptyWidget();
              }
              return ResponsiveContent(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClassesSection(classes: state.classes, onClassTap: () {}),
                      const SizedBox(height: 16),
                      if (state.assignments.isNotEmpty) ...[
                        AssignmentsSection(assignments: state.assignments, onTap: (_) {}),
                        const SizedBox(height: 16),
                      ],
                    
                      const SizedBox(height: 16),
                      QuickActionsSection(
                        onCreateAssignment: () => Navigator.of(context).pushNamed('/new-assignment'),
                        onScheduleZoom: () => Navigator.of(context).pushNamed('/schedule-zoom'),
                        onViewScheduledMeetings: () => Navigator.of(context).pushNamed('/scheduled-meetings'),
                        onOpenAchievements: () => Navigator.of(context).pushNamed('/achievements'),
                      ),
                      SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 80, tablet: 100, desktop: 120)),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: const SharedBottomNavigation(currentIndex: 0),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification/domain/entities/notification_entity.dart';
import 'package:smart_school/routing/app_routes.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';
import 'package:smart_school/widgets/responsive/responsive_helper.dart';
import 'package:smart_school/widgets/shared_bottom_navigation.dart';
import 'package:core/widgets/index.dart';

import '../../../notification/presintation/bloc/notification_bloc.dart';
import '../../../notification/presintation/widgets/notification_card.dart';
import '../bloc/home_bloc.dart';
import '../widgets/app_drawer.dart';
import '../widgets/promo_slider_widget.dart';
import '../widgets/stats_card_widget.dart';
import '../widgets/quick_actions_widget.dart';
import '../widgets/achievements_widget.dart';
import '../widgets/progress_chart_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // تأكد من أن الـ bloc متوفر في الشجرة قبل استخدامه
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationBloc>().add(GetNotificationListEvent());
      context.read<HomeBloc>().add(LoadHomeDataEvent());
    });
  }

  void _markAsRead(NotificationEntity notification) {
    context.read<NotificationBloc>().add(
      UpdateNotificationEvent(
        updatedNotification: notification.copyWith(isRead: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          // If the drawer is open, close it and prevent the app from closing.
          Navigator.of(context).pop();
          return false;
        }
        // Otherwise, allow the default back button behavior.
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawerWidget(),
        appBar: AppBarWidget(
          title: "Smart School",
          actions: [
            // Chat Icon
            AppBarActions.chat(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.tutorChat);
              },
              isDark: Theme.of(context).brightness == Brightness.dark,
            ),
            // Notifications Icon
            AppBarActions.notification(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.notifications);
              },
              isDark: Theme.of(context).brightness == Brightness.dark,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(RefreshHomeDataEvent());
            context.read<NotificationBloc>().add(GetNotificationListEvent());
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // مسافة من الأعلى
                SizedBox(
                  height: ResponsiveHelper.getSpacing(
                    context,
                    mobile: 16,
                    tablet: 20,
                    desktop: 24,
                  ),
                ),
                
                // PromoSlider
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoaded) {
                      return PromoSlider(promos: state.promos);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                
                // مسافة بعد الـ Slider
                const SizedBox(height: 24),
                
                // Home Stats and Progress
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                                      if (state is HomeInitial || state is HomeLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: SmartSchoolLoading(
                          message: 'جاري تحميل البيانات...',
                          type: LoadingType.dots,
                        ),
                      ),
                    );
                  } else if (state is HomeLoaded) {
                      return Column(
                        children: [
                          // بطاقة الإحصائيات
                          StatsCardWidget(stats: state.stats),
                          const SizedBox(height: 20),
                          
                          // الرسم البياني
                          ProgressChartWidget(stats: state.stats),
                          const SizedBox(height: 20),
                          
                          // الإجراءات السريعة
                          QuickActionsWidget(actions: state.quickActions),
                          const SizedBox(height: 20),
                          
                          // الإنجازات
                          AchievementsWidget(achievements: state.achievements),
                          const SizedBox(height: 20),
                        ],
                      );
                    } else if (state is HomeError) {
                      return Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[400],
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'حدث خطأ في تحميل البيانات',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: TextStyle(
                                color: Colors.red[600],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<HomeBloc>().add(LoadHomeDataEvent());
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('إعادة المحاولة'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[600],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Notifications Section
                BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    if (state is NotificationListLoadedState) {
                      final unreadNotifications =
                          state.notificationList
                              .where((notification) => !notification.isRead)
                              .toList();
                      if (unreadNotifications.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Container(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.notifications_active,
                                  color: const Color(0xFFF59E0B), // تحديث اللون
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'إشعارات جديدة',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: unreadNotifications.length,
                              itemBuilder: (context, index) {
                                final notification = unreadNotifications[index];
                                return NotificationCard(
                                  notification: notification,
                                  onTap: () => _markAsRead(notification),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                
                // مسافة من الأسفل
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SharedBottomNavigation(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/widgets/app_exports.dart';
import 'package:core/theme/index.dart';
import 'package:core/widgets/index.dart';
import '../../domain/entities/zoom_meeting.dart';
import '../widgets/zoom_meetings_card_widget.dart';
import '../bloc/zoom_meetings_bloc.dart';
import '../bloc/zoom_meetings_event.dart';
import '../bloc/zoom_meetings_state.dart';

class ZoomMeetingsListPage extends StatefulWidget {
  const ZoomMeetingsListPage({super.key});

  @override
  State<ZoomMeetingsListPage> createState() => _ZoomMeetingsListPageState();
}

class _ZoomMeetingsListPageState extends State<ZoomMeetingsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ZoomMeetingsBloc>().add(const GetZoomMeetings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'جلسات زووم',
        gradientType: GradientType.primary,
        actions: [
          AppBarActions.refresh(
            onPressed: () {
              context.read<ZoomMeetingsBloc>().add(const GetZoomMeetings());
            },
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        ],
      ),
      body: BlocBuilder<ZoomMeetingsBloc, ZoomMeetingsState>(
        builder: (context, state) {
          if (state is ZoomMeetingsLoading) {
            return const SmartSchoolLoading(
              message: 'جاري تحميل جلسات زووم...',
              type: LoadingType.ripple,
            );
          } else if (state is ZoomMeetingsLoaded) {
            final List<ZoomMeeting> meetings = state.meetings;
            if (meetings.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ZoomMeetingsBloc>().add(const GetZoomMeetings());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
                    child: const Center(
                      child: Text(
                        'لا توجد جلسات زووم قادمة حالياً.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ZoomMeetingsBloc>().add(const GetZoomMeetings());
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  itemCount: meetings.length,
                  itemBuilder: (context, index) {
                    return ZoomMeetingsCardWidget(meeting: meetings[index]);
                  },
                ),
              );
            }
          } else if (state is ZoomMeetingsError) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ZoomMeetingsBloc>().add(const GetZoomMeetings());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'خطأ: ${state.message}',
                            style: const TextStyle(fontSize: 18, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ZoomMeetingsBloc>().add(const GetZoomMeetings());
                            },
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(child: Text('جارٍ تهيئة جلسات زووم...'));
        },
      ),
    );
  }
}
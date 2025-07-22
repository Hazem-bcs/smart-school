import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import bloc package
import '../../domain/entities/zoom_meeting.dart';
import '../widgets/zoom_meetings_card_widget.dart';
import '../bloc/zoom_meetings_bloc.dart'; // Import the BLoC
import '../bloc/zoom_meetings_event.dart'; // Import events
import '../bloc/zoom_meetings_state.dart'; // Import states

class ZoomMeetingsListPage extends StatefulWidget {
  const ZoomMeetingsListPage({super.key});

  @override
  State<ZoomMeetingsListPage> createState() => _ZoomMeetingsListPageState();
}

class _ZoomMeetingsListPageState extends State<ZoomMeetingsListPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch the GetZoomMeetings event when the page initializes.
    // We use addPostFrameCallback to ensure the context is available.
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   BlocProvider.of<ZoomMeetingsBloc>(context).add(const GetZoomMeetings());
    // });
    context.read<ZoomMeetingsBloc>().add(const GetZoomMeetings());
  }

  @override
  Widget build(BuildContext context) {
    // Remove _getDummyMeetings() as data will come from the BLoC

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoom Sessions', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF7B61FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<ZoomMeetingsBloc, ZoomMeetingsState>(
        builder: (context, state) {
          if (state is ZoomMeetingsLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF7B61FF)));
          } else if (state is ZoomMeetingsLoaded) {
            final List<ZoomMeeting> meetings = state.meetings;
            if (meetings.isEmpty) {
              return const Center(
                child: Text(
                  'No upcoming Zoom sessions currently.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                itemCount: meetings.length,
                itemBuilder: (context, index) {
                  return ZoomMeetingsCardWidget(meeting: meetings[index]);
                },
              );
            }
          } else if (state is ZoomMeetingsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          // Default state, e.g., when the BLoC is in its initial state
          return const Center(child: Text('Initializing Zoom sessions...'));
        },
      ),
    );
  }
}
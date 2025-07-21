import 'package:flutter/material.dart';
import 'package:smart_school/features/zoom/presentation/pages/zoom_meetings_list_page.dart';

class ZoomMeetingsButton extends StatelessWidget {

  const ZoomMeetingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ZoomMeetingsListPage()),
        );
      },
      icon: const Icon(Icons.videocam, size: 28), // Video camera icon
      label: const Text(
        'Schedule Zoom',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF7B61FF),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            30,
          ),
        ),
        elevation: 5,
      ),
    );
  }
}

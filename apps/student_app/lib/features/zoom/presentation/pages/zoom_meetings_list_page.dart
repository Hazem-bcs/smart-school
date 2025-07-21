import 'package:flutter/material.dart';
import '../../domain/entities/zoom_meeting.dart';
import '../widgets/zoom_meetings_card_widget.dart';

class ZoomMeetingsListPage extends StatelessWidget {
  const ZoomMeetingsListPage({super.key});

  List<ZoomMeeting> _getDummyMeetings() {
    return [
      ZoomMeeting(
        id: '1',
        topic: 'Chapter 5 Review Session: Linear Algebra',
        className: 'Mathematics 101',
        teacher: 'Dr. Ahmed Ali',
        dateTime: DateTime.now().add(const Duration(minutes: 10)),
        zoomLink: 'https://zoom.us/j/1234567890',
        isLive: true,
      ),
      ZoomMeeting(
        id: '2',
        topic: 'Introduction to Object-Oriented Programming (OOP)',
        className: 'Computer Science 303',
        teacher: 'Eng. Sarah Mahmoud',
        dateTime: DateTime.now().add(const Duration(hours: 2)),
        zoomLink: 'https://zoom.us/j/0987654321',
      ),
      ZoomMeeting(
        id: '3',
        topic: 'History of Ancient Civilizations: Pharaonic Egypt',
        className: 'History 202',
        teacher: 'Prof. Fatima El Zahraa',
        dateTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
        zoomLink: 'https://zoom.us/j/1122334455',
      ),
      ZoomMeeting(
        id: '4',
        topic: 'Fundamentals of Nuclear Physics',
        className: 'Physics 505',
        teacher: 'Dr. Youssef El Sherif',
        dateTime: DateTime.now().subtract(const Duration(hours: 5)),
        zoomLink: 'https://zoom.us/j/6677889900',
        isLive: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<ZoomMeeting> meetings = _getDummyMeetings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoom Sessions', style: TextStyle(color: Colors.white)), // تم التعديل هنا
        backgroundColor: const Color(0xFF7B61FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: meetings.isEmpty
          ? const Center(
        child: Text(
          'No upcoming Zoom sessions currently.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        itemCount: meetings.length,
        itemBuilder: (context, index) {
          return ZoomMeetingsCardWidget(meeting: meetings[index]);
        },
      ),
    );
  }
}
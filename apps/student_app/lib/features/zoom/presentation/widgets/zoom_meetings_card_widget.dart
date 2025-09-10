import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/zoom_meeting.dart';

class ZoomMeetingsCardWidget extends StatelessWidget {
  final ZoomMeeting meeting; //entity

  const ZoomMeetingsCardWidget({super.key, required this.meeting});

  Future<void> _launchZoomLink(BuildContext context) async {
    final String raw = meeting.zoomLink.trim();
    if (raw.isEmpty) {
      _showError(context, 'رابط الاجتماع غير متوفر');
      return;
    }

    Uri? candidate = Uri.tryParse(raw) ?? Uri.tryParse(Uri.encodeFull(raw));
    if (candidate == null) {
      _showError(context, 'رابط غير صالح');
      return;
    }

    try {
      final bool openedApp = await launchUrl(candidate, mode: LaunchMode.externalNonBrowserApplication);
      if (openedApp) return;
    } catch (_) {}

    try {
      final bool openedExternal = await launchUrl(candidate, mode: LaunchMode.externalApplication);
      if (openedExternal) return;
    } catch (_) {}

    try {
      final bool openedDefault = await launchUrl(candidate, mode: LaunchMode.platformDefault);
      if (openedDefault) return;
    } catch (_) {}

    try {
      final bool openedInApp = await launchUrl(candidate, mode: LaunchMode.inAppBrowserView);
      if (openedInApp) return;
    } catch (_) {}

    _showError(context, 'تعذر فتح رابط Zoom');
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'd MMMM yyyy',
      'en',
    ).format(meeting.dateTime);
    final String formattedTime = DateFormat(
      'hh:mm a',
      'en',
    ).format(meeting.dateTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedTime,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                if (meeting.isLive) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'live now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meeting.topic,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meeting.className,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF7B61FF),
                    ),
                  ),
                  Text(
                    'Teacher : ${meeting.teacher}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _launchZoomLink(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      meeting.isLive
                          ? Colors.green.shade700
                          : const Color(0xFF7B61FF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.videocam,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

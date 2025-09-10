import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/zoom_meeting_state.dart';
import 'info_row.dart';

class ScheduleMeetingSuccessDialog extends StatelessWidget {
  final ZoomMeetingScheduled state;

  const ScheduleMeetingSuccessDialog({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1F35) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF10B981).withOpacity(0.2)
                    : const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size: 48,
                color: isDark ? const Color(0xFF34D399) : const Color(0xFF10B981),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Meeting Scheduled!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2F45) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  InfoRow(label: 'Meeting ID', value: state.meetingId, isDark: isDark),
                  const SizedBox(height: 8),
                  InfoRow(label: 'Password', value: state.password, isDark: isDark),
                  const SizedBox(height: 16),
                  InfoRow(
                    label: 'Meeting URL',
                    value: state.meetingUrl,
                    isDark: isDark,
                    isUrl: true,
                    onTap: () async {
                      final String url = state.meetingUrl;
                      // حاول فتح تطبيق زووم مباشرة إذا أمكن
                      final Uri? candidate = Uri.tryParse(url) ?? Uri.tryParse(Uri.encodeFull(url));
                      if (candidate != null) {
                        final bool openedApp = await launchUrl(candidate, mode: LaunchMode.externalNonBrowserApplication);
                        if (openedApp) return;
                        final bool openedExternal = await launchUrl(candidate, mode: LaunchMode.externalApplication);
                        if (openedExternal) return;
                        final bool openedDefault = await launchUrl(candidate, mode: LaunchMode.platformDefault);
                        if (openedDefault) return;
                        await launchUrl(candidate, mode: LaunchMode.inAppBrowserView);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF6366F1) : const Color(0xFF5A67D8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
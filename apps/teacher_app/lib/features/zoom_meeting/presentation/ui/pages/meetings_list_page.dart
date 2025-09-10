import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/injection_container.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/entities/zoom_meeting_entity.dart';
import '../../blocs/meetings_list_bloc.dart';
import '../../blocs/meetings_list_event.dart';
import '../../blocs/meetings_list_state.dart';

class MeetingsListPage extends StatefulWidget {
  const MeetingsListPage({super.key});

  @override
  State<MeetingsListPage> createState() => _MeetingsListPageState();
}

class _MeetingsListPageState extends State<MeetingsListPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        toolbarHeight: 48,
        title: Text(
          'الاجتماعات المجدولة على زووم',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => getIt<MeetingsListBloc>()..add(LoadMeetings()),
        child: BlocConsumer<MeetingsListBloc, MeetingsListState>(
          listener: (context, state) async {
            if (state is MeetingJoinLinkReady) {
              final String url = state.url;
              final Uri? candidate = Uri.tryParse(url) ?? Uri.tryParse(Uri.encodeFull(url));
              if (candidate != null) {
                // حاول فتحه بتطبيق زووم مباشرة إن أمكن
                final bool openedApp = await launchUrl(candidate, mode: LaunchMode.externalNonBrowserApplication);
                if (openedApp) return;
                // جرّب الفتح خارج التطبيق، ثم افتراضي النظام، ثم داخل التطبيق
                final bool openedExternal = await launchUrl(candidate, mode: LaunchMode.externalApplication);
                if (!openedExternal) {
                  final bool openedDefault = await launchUrl(candidate, mode: LaunchMode.platformDefault);
                  if (!openedDefault) {
                    await launchUrl(candidate, mode: LaunchMode.inAppBrowserView);
                  }
                }
              }
            }
          },
          builder: (context, state) {
            if (state is MeetingsListLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MeetingsListError) {
              return _ErrorView(
                message: state.message,
                onRetry: () => context.read<MeetingsListBloc>().add(RefreshMeetings()),
              );
            }
            if (state is MeetingsListLoaded) {
              final filtered = state.meetings.where((m) => m.topic.toLowerCase().contains(_query.toLowerCase())).toList();
              if (filtered.isEmpty) {
                return _HeaderAndEmpty(
                  query: _query,
                  onQueryChanged: (q) => setState(() => _query = q),
                );
              }

              // Determine upcoming session to highlight
              final DateTime now = DateTime.now();
              ZoomMeetingEntity? upcoming;
              DateTime? upcomingDt;
              for (final m in filtered) {
                final dt = DateTime(
                  m.scheduledDate.year,
                  m.scheduledDate.month,
                  m.scheduledDate.day,
                  m.scheduledTime.hour,
                  m.scheduledTime.minute,
                );
                if (dt.isAfter(now)) {
                  if (upcomingDt == null || dt.isBefore(upcomingDt)) {
                    upcoming = m;
                    upcomingDt = dt;
                  }
                }
              }

              // Group by date (yyyy-mm-dd)
              final Map<DateTime, List<ZoomMeetingEntity>> groups = {};
              for (final m in filtered) {
                final key = DateTime(m.scheduledDate.year, m.scheduledDate.month, m.scheduledDate.day);
                groups.putIfAbsent(key, () => []).add(m);
              }
              final dates = groups.keys.toList()..sort((a, b) => a.compareTo(b));

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _Header(query: _query, onQueryChanged: (q) => setState(() => _query = q)),
                  ),
                  for (final date in dates) ...[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _DateHeaderDelegate(
                        child: _DateHeader(date: date),
                        minExtent: 40,
                        maxExtent: 40,
                      ),
                    ),
                    _buildMeetingsGrid(groups[date]!, theme, highlight: upcoming),
                  ],
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildMeetingsGrid(List<ZoomMeetingEntity> items, ThemeData theme, {ZoomMeetingEntity? highlight}) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.crossAxisExtent; // approximate viewport width
          final crossAxisCount = width >= 1100 ? 3 : (width >= 750 ? 2 : 1);
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              // جعل البطاقات أطول لتستوعب كافة المحتويات (ID/Password)
              childAspectRatio: crossAxisCount == 1 ? 1.0 : 1.12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final m = items[index];
                final isNext = highlight != null && identical(m, highlight);
                return _MeetingCard(meeting: m, highlight: isNext);
              },
              childCount: items.length,
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String query;
  final ValueChanged<String> onQueryChanged;
  const _Header({required this.query, required this.onQueryChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onQueryChanged,
              decoration: InputDecoration(
                hintText: 'ابحث عن اجتماع ...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderAndEmpty extends StatelessWidget {
  final String query;
  final ValueChanged<String> onQueryChanged;
  const _HeaderAndEmpty({required this.query, required this.onQueryChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _Header(query: query, onQueryChanged: onQueryChanged),
        const SizedBox(height: 32),
        Text('لا توجد نتائج مطابقة', style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _DateHeader extends StatelessWidget {
  final DateTime date;
  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.calendar_today_rounded, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(text, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _DateHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minExtent;
  final double maxExtent;
  const _DateHeaderDelegate({required this.child, required this.minExtent, required this.maxExtent});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;
  @override
  bool shouldRebuild(_DateHeaderDelegate oldDelegate) => false;
}

class _MeetingCard extends StatefulWidget {
  final ZoomMeetingEntity meeting;
  final bool highlight;
  const _MeetingCard({required this.meeting, this.highlight = false});

  @override
  State<_MeetingCard> createState() => _MeetingCardState();
}

class _MeetingCardState extends State<_MeetingCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final m = widget.meeting;
    const durationMinutes = 60; // Placeholder duration

    final cardColor = theme.cardColor;
    final accent = theme.colorScheme.primary;
    final borderColor = widget.highlight ? accent.withOpacity(0.6) : Colors.grey.withOpacity(0.15);
    final shadowColor = _hovered ? theme.shadowColor.withOpacity(0.2) : theme.shadowColor.withOpacity(0.08);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, opacity, child) => Opacity(opacity: opacity, child: child),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: widget.highlight ? 2 : 1),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: _hovered ? 14 : 8,
                offset: Offset(0, _hovered ? 8 : 4),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isCompact = constraints.maxWidth < 360;
              final title = Text(
                m.topic,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              );
              final meta = Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Text('${m.scheduledDate.year}/${m.scheduledDate.month.toString().padLeft(2, '0')}/${m.scheduledDate.day.toString().padLeft(2, '0')}',
                      style: theme.textTheme.bodyMedium),
                  const SizedBox(width: 14),
                  Icon(Icons.access_time_rounded, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Text('${m.scheduledTime.hour.toString().padLeft(2, '0')}:${m.scheduledTime.minute.toString().padLeft(2, '0')}',
                      style: theme.textTheme.bodyMedium),
                  const SizedBox(width: 14),
                  Icon(Icons.timer_rounded, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Text('$durationMinutes دقيقة', style: theme.textTheme.bodyMedium),
                ],
              );

              final hasMeetingId = (m.meetingId ?? '').isNotEmpty;
              final hasPassword = (m.password ?? '').isNotEmpty;
              final creds = (hasMeetingId || hasPassword)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (hasMeetingId)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.confirmation_number_rounded, size: 16, color: theme.colorScheme.primary),
                                const SizedBox(width: 6),
                                Text('معرّف الاجتماع: ${m.meetingId}', style: theme.textTheme.bodyMedium),
                              ],
                            ),
                          if (hasPassword)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.lock_rounded, size: 16, color: theme.colorScheme.primary),
                                const SizedBox(width: 6),
                                Text('كلمة المرور: ${m.password}', style: theme.textTheme.bodyMedium),
                              ],
                            ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink();

              final joinButton = ElevatedButton.icon(
                onPressed: () async {
                  // إذا كان لدينا بيانات الاجتماع، حاول الفتح عبر تطبيق زووم أولاً
                  final String? meetingId = m.meetingId;
                  final String? pwd = m.password;
                  if (meetingId != null && meetingId.isNotEmpty) {
                    final String scheme = 'zoomus://zoom.us/join?confno=$meetingId${(pwd != null && pwd.isNotEmpty) ? '&pwd=$pwd' : ''}';
                    final Uri? zoomAppUri = Uri.tryParse(scheme);
                    if (zoomAppUri != null) {
                      final bool openedZoomApp = await launchUrl(zoomAppUri, mode: LaunchMode.externalNonBrowserApplication);
                      if (openedZoomApp) return;
                    }
                  }

                  // إذا كان لدينا رابط مباشر من الخادم، حاول كذلك بترتيب يفضّل التطبيق
                  final String? directUrl = m.meetingUrl;
                  if (directUrl != null && directUrl.isNotEmpty) {
                    final Uri? candidate = Uri.tryParse(directUrl) ?? Uri.tryParse(Uri.encodeFull(directUrl));
                    if (candidate != null) {
                      final bool openedApp = await launchUrl(candidate, mode: LaunchMode.externalNonBrowserApplication);
                      if (openedApp) return;
                      final bool openedExternal = await launchUrl(candidate, mode: LaunchMode.externalApplication);
                      if (openedExternal) return;
                      final bool openedDefault = await launchUrl(candidate, mode: LaunchMode.platformDefault);
                      if (openedDefault) return;
                      final bool openedInApp = await launchUrl(candidate, mode: LaunchMode.inAppBrowserView);
                      if (openedInApp) return;
                    }
                  }
                  context.read<MeetingsListBloc>().add(JoinMeetingRequested(widget.meeting.meetingId ?? widget.meeting.id));
                },
                icon: const Icon(Icons.video_call_rounded, size: 18),
                label: const Text('انضمام'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isCompact) ...[
                    title,
                    const SizedBox(height: 8),
                    meta,
                    creds,
                    const SizedBox(height: 12),
                    SizedBox(width: double.infinity, child: joinButton),
                  ] else ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              title,
                              const SizedBox(height: 8),
                              meta,
                              creds,
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        joinButton,
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: m.invitedClasses.map((c) => _ClassChip(text: c)).toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ClassChip extends StatelessWidget {
  final String text;
  const _ClassChip({required this.text});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Text(text, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ),
    );
  }
}



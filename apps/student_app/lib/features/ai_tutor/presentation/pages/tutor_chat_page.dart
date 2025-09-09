import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../bloc/tutor_chat_bloc.dart';

class TutorChatView extends StatefulWidget {
  const TutorChatView({super.key});

  @override
  State<TutorChatView> createState() => _TutorChatViewState();
}

class _TutorChatViewState extends State<TutorChatView> with TickerProviderStateMixin {
  final _chatController = types.InMemoryChatController();

  final _user = types.User(id: ChatAuthor.user.toString());
  final _aiTutor = types.User(id: ChatAuthor.ai.toString(), name: 'المدرس الذكي');

  late final AnimationController _bgPulseController;
  bool _isBotTyping = false;

  @override
  void initState() {
    super.initState();
    _bgPulseController = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgPulseController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final appBarHeight = kToolbarHeight + mediaQuery.padding.top;
    const composerHeight = 0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: _GlassAppBar(title: 'المدرس الذكي 🤖', colorScheme: colorScheme, isDark: isDark),
      ),
      body: Stack(
        children: [
          _AnimatedPastelBackground(animation: _bgPulseController, colorScheme: colorScheme, isDark: isDark),
          Positioned.fill(
            top: appBarHeight,
            bottom: composerHeight + mediaQuery.padding.bottom,
            child: BlocListener<ChatBloc, ChatState>(
              listener: (context, state) async {
                if (state is ChatErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                  setState(() => _isBotTyping = false);
                }
                if (state is ChatSuccessState) {
                  if (state.messages.author == ChatAuthor.user) {
                    // insert user echo and show typing
                    _chatController.insertMessage(
                      types.TextMessage(
                        id: state.messages.id,
                        createdAt: state.messages.createdAt,
                        authorId: _user.id,
                        text: state.messages.text,
                      ),
                    );
                    setState(() => _isBotTyping = true);
                  } else {
                    // AI response split into paragraphs and fade-in
                    await _insertBotReplyWithParagraphs(state.messages);
                    setState(() => _isBotTyping = false);
                  }
                }
              },
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  return _GlassChatSurface(
                    chatController: _chatController,
                    currentUser: _user,
                    aiUser: _aiTutor,
                    onMessageSend: (message) => context.read<ChatBloc>().add(SendMessageEvent(message: message)),
                    colorScheme: colorScheme,
                    isDark: isDark,
                  );
                },
              ),
            ),
          ),
          if (_isBotTyping)
            Positioned(
              left: 16,
              bottom: composerHeight + mediaQuery.padding.bottom + 12,
              child: _TypingIndicatorChip(colorScheme: colorScheme, isDark: isDark),
            ),
          // Custom input removed to keep a single composer (Chat's built-in)
          
        ],
      ),
    );
  }

  Future<void> _insertBotReplyWithParagraphs(MessageEntity message) async {
    final parts = _splitIntoParagraphs(message.text);
    for (int i = 0; i < parts.length; i++) {
      final botPart = types.TextMessage(
        id: '${message.id}-$i',
        createdAt: message.createdAt.add(Duration(milliseconds: 10 * i)),
        authorId: _aiTutor.id,
        text: parts[i],
      );
      _chatController.insertMessage(botPart);
      await Future.delayed(const Duration(milliseconds: 140));
    }
  }

  List<String> _splitIntoParagraphs(String text) {
    final normalized = text.replaceAll('\r\n', '\n');
    final paragraphs = normalized.split(RegExp(r'\n\n+')).where((p) => p.trim().isNotEmpty).toList();
    if (paragraphs.isNotEmpty) return paragraphs;
    const chunkSize = 280;
    if (text.length <= chunkSize) return [text];
    final chunks = <String>[];
    for (int i = 0; i < text.length; i += chunkSize) {
      chunks.add(text.substring(i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
    return chunks;
  }
}

class _GlassAppBar extends StatelessWidget {
  final String title;
  final ColorScheme colorScheme;
  final bool isDark;
  const _GlassAppBar({required this.title, required this.colorScheme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    return Container(
      height: kToolbarHeight + paddingTop,
      padding: EdgeInsets.only(top: paddingTop),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(isDark ? 0.18 : 0.14),
              border: Border(
                bottom: BorderSide(color: colorScheme.onSurface.withOpacity(0.20), width: 1),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.psychology, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(color: colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(isDark ? 0.18 : 0.14),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: colorScheme.onSurface.withOpacity(0.20), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, color: colorScheme.onSurface, size: 16),
                      const SizedBox(width: 6),
                      Text('AI', style: TextStyle(color: colorScheme.onSurface, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedPastelBackground extends StatelessWidget {
  final Animation<double> animation;
  final ColorScheme colorScheme;
  final bool isDark;
  const _AnimatedPastelBackground({required this.animation, required this.colorScheme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = animation.value;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1B3A) : null,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: isDark
                    ? const SizedBox.shrink()
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.surfaceVariant,
                              colorScheme.primary.withOpacity(0.20),
                              colorScheme.secondary.withOpacity(0.20),
                            ],
                          ),
                        ),
                      ),
              ),
              _blurCircle(Offset(60 + 10 * t, 140 - 8 * t), 140, isDark ? Colors.white.withOpacity(0.06) : colorScheme.onSurface.withOpacity(0.18)),
              _blurCircle(Offset(250 - 8 * t, 420 + 10 * t), 180, isDark ? Colors.white.withOpacity(0.05) : colorScheme.onSurface.withOpacity(0.14)),
              _blurCircle(Offset(-40 + 6 * t, 600 - 6 * t), 160, isDark ? Colors.white.withOpacity(0.04) : colorScheme.onSurface.withOpacity(0.12)),
            ],
          ),
        );
      },
    );
  }

  Widget _blurCircle(Offset offset, double size, Color color) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class _TypingIndicatorChip extends StatefulWidget {
  final ColorScheme colorScheme;
  final bool isDark;
  const _TypingIndicatorChip({required this.colorScheme, required this.isDark});
  @override
  State<_TypingIndicatorChip> createState() => _TypingIndicatorChipState();
}

class _TypingIndicatorChipState extends State<_TypingIndicatorChip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.colorScheme.surface.withOpacity(widget.isDark ? 0.20 : 0.16),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.colorScheme.onSurface.withOpacity(0.22), width: 1),
          ),
          child: Row(
            children: [
              Icon(Icons.psychology, color: widget.colorScheme.onSurface, size: 16),
              const SizedBox(width: 8),
              AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  final v = _controller.value;
                  return Row(
                    children: List.generate(3, (i) {
                      final opacity = 0.3 + 0.7 * (1 - ((v + i * 0.2) % 1));
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: widget.colorScheme.onSurface.withOpacity(opacity),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _GlassChatSurface extends StatelessWidget {
  final types.InMemoryChatController chatController;
  final types.User currentUser;
  final types.User aiUser;
  final ValueChanged<String> onMessageSend;
  final ColorScheme colorScheme;
  final bool isDark;

  const _GlassChatSurface({
    required this.chatController,
    required this.currentUser,
    required this.aiUser,
    required this.onMessageSend,
    required this.colorScheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(isDark ? 0.10 : 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colorScheme.onSurface.withOpacity(0.20), width: 1),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                brightness: isDark ? Brightness.dark : Brightness.light,
                colorScheme: colorScheme,
                scaffoldBackgroundColor: Colors.transparent,
                canvasColor: Colors.transparent,
                cardColor: colorScheme.surface.withOpacity(isDark ? 0.20 : 0.10),
                dividerColor: colorScheme.onSurface.withOpacity(0.12),
                iconTheme: Theme.of(context).iconTheme.copyWith(color: colorScheme.onSurface),
                textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: colorScheme.onSurface,
                      displayColor: colorScheme.onSurface,
                    ),
              ),
              child: Chat(
                onMessageSend: onMessageSend,
                currentUserId: currentUser.id,
                resolveUser: (types.UserID id) async {
                  if (id == currentUser.id) return currentUser;
                  return aiUser;
                },
                chatController: chatController,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
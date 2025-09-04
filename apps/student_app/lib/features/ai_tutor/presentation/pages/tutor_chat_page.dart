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
    final appBarHeight = kToolbarHeight + mediaQuery.padding.top;
    const composerHeight = 0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: const _GlassAppBar(title: 'المدرس الذكي 🤖'),
      ),
      body: Stack(
        children: [
          _AnimatedPastelBackground(animation: _bgPulseController),
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
                  );
                },
              ),
            ),
          ),
          if (_isBotTyping)
            Positioned(
              left: 16,
              bottom: composerHeight + mediaQuery.padding.bottom + 12,
              child: const _TypingIndicatorChip(),
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
  const _GlassAppBar({required this.title});

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
              color: Colors.white.withOpacity(0.18),
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.25), width: 1),
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
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C4DFF), Color(0xFF00BCD4)],
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text('AI', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
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
  const _AnimatedPastelBackground({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = animation.value;
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFB3E5FC), Color(0xFFE1BEE7), Color(0xFFC8E6C9)],
            ),
          ),
          child: Stack(
            children: [
              _blurCircle(Offset(60 + 10 * t, 140 - 8 * t), 140, Colors.white.withOpacity(0.25)),
              _blurCircle(Offset(250 - 8 * t, 420 + 10 * t), 180, Colors.white.withOpacity(0.18)),
              _blurCircle(Offset(-40 + 6 * t, 600 - 6 * t), 160, Colors.white.withOpacity(0.15)),
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
  const _TypingIndicatorChip();
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
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.psychology, color: Colors.white, size: 16),
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
                          color: Colors.white.withOpacity(opacity),
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

  const _GlassChatSurface({
    required this.chatController,
    required this.currentUser,
    required this.aiUser,
    required this.onMessageSend,
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
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
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
    );
  }
}
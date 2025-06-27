import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../../../../widgets/app_bar_widget.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../bloc/tutor_chat_bloc.dart';

class TutorChatView extends StatefulWidget {
  const TutorChatView({super.key});

  @override
  State<TutorChatView> createState() => _TutorChatViewState();
}

class _TutorChatViewState extends State<TutorChatView> {
  final _chatController = types.InMemoryChatController();

  final _user = types.User(id: ChatAuthor.user.toString());
  final _aiTutor = types.User(id: ChatAuthor.ai.toString(), name: 'المدرس الذكي');

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Assistant Bot 🤖"),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is ChatSuccessState) {
            _chatController.insertMessage(
              types.TextMessage(
                id: state.messages.id,
                createdAt: state.messages.createdAt,
                authorId: state.messages.author.toString(),
                text: state.messages.text,
              ),
            );
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return Chat(

              onMessageSend: (message) {
                context.read<ChatBloc>().add(SendMessageEvent(message: message));
              },
              currentUserId: _user.id,
              resolveUser: (types.UserID id) async {
                // تحديد المستخدم بناءً على الـ ID
                if (id == _user.id) return _user;
                return _aiTutor;
              },
              chatController: _chatController,
            );
          },
        ),
      ),
    );
  }
}

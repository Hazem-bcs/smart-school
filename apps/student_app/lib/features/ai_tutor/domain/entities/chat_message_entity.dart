import 'package:equatable/equatable.dart';

enum ChatAuthor { user, ai }
class MessageEntity extends Equatable {
  final String id;
  final String text;
  final ChatAuthor author;
  final DateTime createdAt;


  const MessageEntity({
    required this.id,
    required this.text,
    required this.author,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, text, author];

  MessageEntity copyWith({
    String? id,
    ChatAuthor? author,
    String? text,
    DateTime? createdAt,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      author: author ?? this.author,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
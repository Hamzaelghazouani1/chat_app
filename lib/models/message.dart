import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String conversationId;
  final String content;
  final bool isMe;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.isMe,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, conversationId, content, isMe, timestamp];
}

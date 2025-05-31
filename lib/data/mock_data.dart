import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';

// Mock conversations
final List<Conversation> mockConversations = [
  Conversation(
    id: '1',
    contactName: 'Alice',
    lastMessage: 'Bonjour, comment vas-tu?',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    unreadCount: 2,
  ),
  Conversation(
    id: '2',
    contactName: 'Bob',
    lastMessage: 'On se voit demain?',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    unreadCount: 0,
  ),
  Conversation(
    id: '3',
    contactName: 'Charlie',
    lastMessage: 'J\'ai envoyé le document',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    unreadCount: 1,
  ),
  Conversation(
    id: '4',
    contactName: 'David',
    lastMessage: 'Merci pour ton aide!',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    unreadCount: 0,
  ),
];

// Mock messages
final Map<String, List<Message>> mockMessages = {
  '1': [
    Message(
      id: '101',
      conversationId: '1',
      content: 'Salut Alice!',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
    ),
    Message(
      id: '102',
      conversationId: '1',
      content: 'Salut! Comment vas-tu?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Message(
      id: '103',
      conversationId: '1',
      content: 'Je vais bien, merci. Et toi?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    Message(
      id: '104',
      conversationId: '1',
      content: 'Très bien! Tu fais quoi ce weekend?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Message(
      id: '105',
      conversationId: '1',
      content: 'Je n\'ai pas encore de plans',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Message(
      id: '106',
      conversationId: '1',
      content: 'Bonjour, comment vas-tu?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ],
  '2': [
    Message(
      id: '201',
      conversationId: '2',
      content: 'Salut Bob, tu es libre demain?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Message(
      id: '202',
      conversationId: '2',
      content: 'Oui, pourquoi?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
    ),
    Message(
      id: '203',
      conversationId: '2',
      content: 'On pourrait aller au cinéma',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
    ),
    Message(
      id: '204',
      conversationId: '2',
      content: 'On se voit demain?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ],
  '3': [
    Message(
      id: '301',
      conversationId: '3',
      content: 'Bonjour Charlie, peux-tu m\'envoyer le document?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
    ),
    Message(
      id: '302',
      conversationId: '3',
      content: 'Bien sûr, je te l\'envoie tout de suite',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
    ),
    Message(
      id: '303',
      conversationId: '3',
      content: 'J\'ai envoyé le document',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ],
  '4': [
    Message(
      id: '401',
      conversationId: '4',
      content: 'David, j\'ai besoin d\'aide pour le projet',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Message(
      id: '402',
      conversationId: '4',
      content: 'Pas de problème, je peux t\'aider',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
    ),
    Message(
      id: '403',
      conversationId: '4',
      content: 'Merci pour ton aide!',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ],
};

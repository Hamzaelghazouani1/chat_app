import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';

// Mock conversations
final List<Conversation> mockConversations = [
  Conversation(
    id: '1',
    contactName: 'Hamza El Ghazouani',
    lastMessage: 'On se voit au café ce soir?',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    unreadCount: 2,
  ),
  Conversation(
    id: '2',
    contactName: 'Salah',
    lastMessage: 'J\'ai trouvé le livre dont je t\'ai parlé',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    unreadCount: 0,
  ),
  Conversation(
    id: '3',
    contactName: 'Mohammed',
    lastMessage: 'Le match commence à 20h',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    unreadCount: 1,
  ),
  Conversation(
    id: '4',
    contactName: 'Hassan',
    lastMessage: 'Merci pour ton aide avec le projet!',
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
      content: 'Salut Hamza!',
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
      content: 'Très bien, merci. Tu as des plans pour ce weekend?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    Message(
      id: '104',
      conversationId: '1',
      content: 'Je pensais aller au cinéma. Tu veux venir?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Message(
      id: '105',
      conversationId: '1',
      content: 'Bonne idée! Quel film?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Message(
      id: '106',
      conversationId: '1',
      content: 'On se voit au café ce soir?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ],
  '2': [
    Message(
      id: '201',
      conversationId: '2',
      content: 'Salah, tu as trouvé ce livre sur le développement Flutter?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Message(
      id: '202',
      conversationId: '2',
      content: 'Oui, je l\'ai vu à la librairie du centre',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
    ),
    Message(
      id: '203',
      conversationId: '2',
      content: 'Super! Je vais y passer demain',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
    ),
    Message(
      id: '204',
      conversationId: '2',
      content: 'J\'ai trouvé le livre dont je t\'ai parlé',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ],
  '3': [
    Message(
      id: '301',
      conversationId: '3',
      content: 'Mohammed, on regarde le match ensemble ce soir?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
    ),
    Message(
      id: '302',
      conversationId: '3',
      content: 'Bien sûr! Chez moi ou chez toi?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
    ),
    Message(
      id: '303',
      conversationId: '3',
      content: 'Le match commence à 20h',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ],
  '4': [
    Message(
      id: '401',
      conversationId: '4',
      content: 'Hassan, j\'ai besoin d\'aide pour le projet Flutter',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Message(
      id: '402',
      conversationId: '4',
      content: 'Pas de problème, je peux t\'aider. Qu\'est-ce qui ne va pas?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
    ),
    Message(
      id: '403',
      conversationId: '4',
      content: 'Merci pour ton aide avec le projet!',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ],
};

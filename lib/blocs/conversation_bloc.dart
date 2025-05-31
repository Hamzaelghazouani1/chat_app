import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/data/mock_data.dart';

// Events
abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object?> get props => [];
}

class LoadConversations extends ConversationEvent {}

class SendMessage extends ConversationEvent {
  final String conversationId;
  final String content;

  const SendMessage(this.conversationId, this.content);

  @override
  List<Object?> get props => [conversationId, content];
}

class ReceiveMessage extends ConversationEvent {
  final String conversationId;
  final String content;
  final DateTime timestamp;

  const ReceiveMessage(this.conversationId, this.content,
      {required this.timestamp});

  @override
  List<Object?> get props => [conversationId, content, timestamp];
}

class LoadMessages extends ConversationEvent {
  final String conversationId;

  const LoadMessages(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class CreateConversation extends ConversationEvent {
  final String contactName;

  const CreateConversation(this.contactName);

  @override
  List<Object?> get props => [contactName];
}

// States
abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object?> get props => [];
}

class ConversationsLoading extends ConversationState {}

class ConversationsLoaded extends ConversationState {
  final List<Conversation> conversations;

  const ConversationsLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class MessagesLoaded extends ConversationState {
  final List<Message> messages;
  final String conversationId;
  final List<Conversation> conversations;

  const MessagesLoaded(this.messages, this.conversationId, this.conversations);

  @override
  List<Object?> get props => [messages, conversationId, conversations];
}

class ConversationError extends ConversationState {
  final String message;

  const ConversationError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  List<Conversation> _conversations = [];
  Map<String, List<Message>> _messages = {};

  ConversationBloc() : super(ConversationsLoading()) {
    on<LoadConversations>(_onLoadConversations);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<CreateConversation>(_onCreateConversation);

    // Initialize with mock data
    _conversations = List.from(mockConversations);
    _messages = Map.from(mockMessages);
  }

  void _onLoadConversations(
      LoadConversations event, Emitter<ConversationState> emit) {
    emit(ConversationsLoaded(_conversations));
  }

  void _onLoadMessages(LoadMessages event, Emitter<ConversationState> emit) {
    final messages = _messages[event.conversationId] ?? [];

    // Mark messages as read by updating the conversation
    _conversations = _conversations.map((conversation) {
      if (conversation.id == event.conversationId) {
        return Conversation(
          id: conversation.id,
          contactName: conversation.contactName,
          lastMessage: conversation.lastMessage,
          timestamp: conversation.timestamp,
          unreadCount: 0, // Reset unread count to 0
        );
      }
      return conversation;
    }).toList();

    emit(MessagesLoaded(messages, event.conversationId, _conversations));
  }

  void _onSendMessage(SendMessage event, Emitter<ConversationState> emit) {
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: event.conversationId,
      content: event.content,
      isMe: true,
      timestamp: DateTime.now(),
    );

    // Add message to conversation
    if (_messages.containsKey(event.conversationId)) {
      _messages[event.conversationId] = [
        ..._messages[event.conversationId]!,
        newMessage
      ];
    } else {
      _messages[event.conversationId] = [newMessage];
    }

    // Update conversation with last message
    _conversations = _conversations.map((conversation) {
      if (conversation.id == event.conversationId) {
        return Conversation(
          id: conversation.id,
          contactName: conversation.contactName,
          lastMessage: event.content,
          timestamp: DateTime.now(),
          unreadCount: conversation.unreadCount,
        );
      }
      return conversation;
    }).toList();

    // Sort conversations by timestamp (newest first)
    _conversations.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    emit(MessagesLoaded(_messages[event.conversationId]!, event.conversationId,
        _conversations));
  }

  void _onReceiveMessage(
      ReceiveMessage event, Emitter<ConversationState> emit) {
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: event.conversationId,
      content: event.content,
      isMe: false,
      timestamp: event.timestamp,
    );

    // Add message to conversation
    if (_messages.containsKey(event.conversationId)) {
      _messages[event.conversationId] = [
        ..._messages[event.conversationId]!,
        newMessage
      ];
    } else {
      _messages[event.conversationId] = [newMessage];
    }

    // Update conversation with last message and increment unread count
    _conversations = _conversations.map((conversation) {
      if (conversation.id == event.conversationId) {
        return Conversation(
          id: conversation.id,
          contactName: conversation.contactName,
          lastMessage: event.content,
          timestamp: event.timestamp,
          unreadCount: conversation.unreadCount + 1,
        );
      }
      return conversation;
    }).toList();

    // Sort conversations by timestamp (newest first)
    _conversations.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Emit new state
    final currentState = state;
    if (currentState is MessagesLoaded &&
        currentState.conversationId == event.conversationId) {
      emit(MessagesLoaded(_messages[event.conversationId]!,
          event.conversationId, _conversations));
    } else {
      emit(ConversationsLoaded(_conversations));
    }
  }

  void _onCreateConversation(
      CreateConversation event, Emitter<ConversationState> emit) {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();

    final newConversation = Conversation(
      id: newId,
      contactName: event.contactName,
      lastMessage: '',
      timestamp: DateTime.now(),
      unreadCount: 0,
    );

    _conversations = [newConversation, ..._conversations];
    _messages[newId] = [];

    emit(ConversationsLoaded(_conversations));
  }
}

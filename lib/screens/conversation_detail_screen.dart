import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/blocs/conversation_bloc.dart';
import 'package:chat_app/models/message.dart';
import 'package:intl/intl.dart';

class ConversationDetailScreen extends StatefulWidget {
  final String conversationId;
  final String contactName;

  const ConversationDetailScreen({
    super.key,
    required this.conversationId,
    required this.contactName,
  });

  @override
  State<ConversationDetailScreen> createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ConversationBloc>().add(LoadMessages(widget.conversationId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _simulateReceiveMessage() {
    // Liste de réponses possibles
    final List<String> responses = [
      "D'accord, je comprends.",
      "Merci pour l'information!",
      "Intéressant, dis-m'en plus.",
      "Je ne suis pas sûr de comprendre. Peux-tu clarifier?",
      "Bien reçu!",
      "Je vais y réfléchir et te répondre plus tard.",
      "Super! On en discute bientôt.",
    ];

    // Choisir une réponse aléatoire
    final random = DateTime.now().millisecondsSinceEpoch % responses.length;
    final response = responses[random];

    // Simuler une réponse après 1-3 secondes
    final delay = 1 + (DateTime.now().millisecondsSinceEpoch % 3);
    Future.delayed(Duration(seconds: delay), () {
      if (mounted) {
        context.read<ConversationBloc>().add(
              ReceiveMessage(
                widget.conversationId,
                response,
                timestamp: DateTime.now(),
              ),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactName),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ConversationBloc, ConversationState>(
              listener: (context, state) {
                if (state is MessagesLoaded &&
                    state.conversationId == widget.conversationId) {
                  // Scroll to bottom when messages are loaded or a new message is sent
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToBottom());
                }
              },
              builder: (context, state) {
                if (state is MessagesLoaded &&
                    state.conversationId == widget.conversationId) {
                  return _buildMessagesList(state.messages);
                } else if (state is ConversationsLoaded ||
                    state is ConversationsLoading) {
                  // Si on a seulement les conversations chargées ou en cours de chargement, demander les messages
                  context
                      .read<ConversationBloc>()
                      .add(LoadMessages(widget.conversationId));
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ConversationError) {
                  return Center(child: Text('Erreur: ${state.message}'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessagesList(List<Message> messages) {
    if (messages.isEmpty) {
      return const Center(
        child: Text('Aucun message. Commencez la conversation!'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isMe = message.isMe;
    final dateFormat = DateFormat.Hm();

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateFormat.format(message.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Écrivez un message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 5,
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                context.read<ConversationBloc>().add(
                      SendMessage(
                          widget.conversationId, _messageController.text),
                    );
                _messageController.clear();

                // Simuler une réponse
                _simulateReceiveMessage();
              }
            },
            mini: true,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

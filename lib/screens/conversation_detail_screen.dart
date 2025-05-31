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
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue[100],
              child: Text(
                widget.contactName[0].toUpperCase(),
                style: TextStyle(
                    color: Colors.blue[800], fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Text(widget.contactName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Fonctionnalité d\'appel à venir')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Options à venir')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ConversationBloc, ConversationState>(
                listener: (context, state) {
                  if (state is MessagesLoaded &&
                      state.conversationId == widget.conversationId) {
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
      ),
      resizeToAvoidBottomInset: true,
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
    final bubbleColor =
        isMe ? Theme.of(context).primaryColor : Colors.grey[200];
    final textColor = isMe ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[100],
              child: Text(
                widget.contactName[0].toUpperCase(),
                style: TextStyle(
                    color: Colors.blue[800], fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: isMe ? 64.0 : 0.0,
                right: isMe ? 0.0 : 64.0,
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(message.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: isMe ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          if (isMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[700],
              child: const Text(
                'ME',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        top: 8.0,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? 8.0
            : MediaQuery.of(context).padding.bottom + 8.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {
                // Fonctionnalité d'attachement de fichier
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité à venir')),
                );
              },
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Message...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                ),
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 5,
              ),
            ),
            const SizedBox(width: 4.0),
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: FloatingActionButton(
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
                elevation: 1,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

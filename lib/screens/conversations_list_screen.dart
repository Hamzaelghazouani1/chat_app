import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/blocs/conversation_bloc.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/screens/conversation_detail_screen.dart';
import 'package:intl/intl.dart';

class ConversationsListScreen extends StatelessWidget {
  const ConversationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
          if (state is ConversationsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ConversationsLoaded) {
            return _buildConversationsList(context, state.conversations);
          } else if (state is MessagesLoaded) {
            return _buildConversationsList(context, state.conversations);
          } else {
            return const Center(child: Text('Une erreur est survenue'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewConversationDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildConversationsList(
      BuildContext context, List<Conversation> conversations) {
    if (conversations.isEmpty) {
      return const Center(
        child: Text('Aucune conversation. Créez-en une nouvelle!'),
      );
    }

    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return _buildConversationItem(context, conversation);
      },
    );
  }

  Widget _buildConversationItem(
      BuildContext context, Conversation conversation) {
    // Format date intelligemment
    String timeString;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(
      conversation.timestamp.year,
      conversation.timestamp.month,
      conversation.timestamp.day,
    );

    if (messageDate == today) {
      // Aujourd'hui: afficher l'heure
      timeString = DateFormat.Hm().format(conversation.timestamp);
    } else if (messageDate == yesterday) {
      // Hier
      timeString = 'Hier';
    } else if (now.difference(conversation.timestamp).inDays < 7) {
      // Cette semaine: afficher le jour
      timeString = DateFormat.E().format(conversation.timestamp);
    } else {
      // Plus ancien: afficher la date
      timeString = DateFormat.yMd().format(conversation.timestamp);
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          conversation.contactName[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        conversation.contactName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        conversation.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(timeString, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          if (conversation.unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Text(
                conversation.unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationDetailScreen(
              conversationId: conversation.id,
              contactName: conversation.contactName,
            ),
          ),
        );
      },
    );
  }

  void _showNewConversationDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle conversation'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nom du contact',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<ConversationBloc>().add(
                      CreateConversation(controller.text),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}

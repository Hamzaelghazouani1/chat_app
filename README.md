# Chat App - Application de Messagerie Flutter

## Compte Rendu Détaillé

Cette application de messagerie développée avec Flutter offre une interface intuitive et moderne pour échanger des messages entre utilisateurs. Ce document technique présente l'architecture, les fonctionnalités et les choix d'implémentation qui ont guidé le développement de cette solution de communication mobile.

## Table des matières
1. [Introduction](#introduction)
2. [Configuration Technique](#configuration-technique)
3. [Architecture](#architecture)
4. [Modèle de données](#modèle-de-données)
5. [Fonctionnalités](#fonctionnalités)
6. [Interface Utilisateur](#interface-utilisateur)
7. [Logique de l'application](#logique-de-lapplication)
8. [Outils et dépendances](#outils-et-dépendances)
9. [Perspectives d'évolution](#perspectives-dévolution)

## Introduction

Cette application de messagerie développée avec Flutter offre une interface intuitive et moderne pour échanger des messages entre utilisateurs. Elle permet de gérer plusieurs conversations simultanées, d'envoyer et recevoir des messages textuels, et de suivre l'état des messages (lus/non lus).

L'application a été conçue en suivant les meilleures pratiques de développement mobile, avec une attention particulière portée à l'expérience utilisateur, la performance et la maintenabilité du code.

## Configuration Technique

- **IDE**: Visual Studio Code
- **Dart SDK**: 3.2.0
- **Flutter**: 3.16.0
- **Système d'exploitation de développement**: Windows 11
- **Appareils cibles**: Android 6.0+ / iOS 11.0+
- **Gestion de version**: Git

**Avantages de l'architecture BLoC :**
- Séparation claire entre UI et logique métier
- Gestion réactive de l'état
- Facilité de test des composants logiques
- Flux de données unidirectionnel et prévisible
- Réutilisabilité des composants

## Outils et dépendances

- **Flutter**: Framework UI pour le développement multiplateforme
- **flutter_bloc**: Implémentation du pattern BLoC pour la gestion d'état
- **equatable**: Simplification des comparaisons d'objets
- **intl**: Internationalisation et formatage de dates
- **Material Design**: Directives de conception pour une interface cohérente


### Dépendances principales
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  intl: ^0.18.1
  cupertino_icons: ^1.0.6
```

## Architecture

L'application suit l'architecture BLoC (Business Logic Component) qui sépare la logique métier de l'interface utilisateur. Cette architecture permet une meilleure testabilité et maintenabilité du code.

### Structure des dossiers
```
lib/
├── blocs/           # Gestion de l'état avec BLoC
├── data/            # Sources de données et modèles
├── models/          # Classes de modèles de données
├── screens/         # Écrans de l'application
├── widgets/         # Widgets réutilisables
└── main.dart        # Point d'entrée de l'application
```

Cette organisation modulaire facilite la navigation dans le code source et respecte le principe de responsabilité unique, où chaque fichier a un rôle clairement défini.

## Modèle de données

L'application s'articule autour de deux modèles de données principaux, conçus pour être immuables et facilement sérialisables.

### Classe Message

```dart
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
```

**Fonctionnalités du modèle Message :**
- **Identifiant unique** (`id`) : Permet de référencer chaque message de manière unique
- **Référence à la conversation** (`conversationId`) : Lie le message à une conversation spécifique
- **Contenu du message** (`content`) : Stocke le texte du message
- **Indicateur d'expéditeur** (`isMe`) : Différencie les messages envoyés par l'utilisateur de ceux reçus
- **Horodatage** (`timestamp`) : Enregistre la date et l'heure d'envoi du message
- **Équivalence** : Hérite d'`Equatable` pour faciliter les comparaisons d'objets

### Classe Conversation

```dart
class Conversation extends Equatable {
  final String id;
  final String contactName;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  
  const Conversation({
    required this.id,
    required this.contactName,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
  });
  
  @override
  List<Object?> get props => [id, contactName, lastMessage, timestamp, unreadCount];
}
```

**Fonctionnalités du modèle Conversation :**
- **Identifiant unique** (`id`) : Permet de référencer chaque conversation de manière unique
- **Nom du contact** (`contactName`) : Stocke le nom de l'interlocuteur
- **Dernier message** (`lastMessage`) : Contient le texte du dernier message échangé pour l'aperçu
- **Horodatage** (`timestamp`) : Enregistre la date et l'heure du dernier message pour le tri chronologique
- **Compteur de messages non lus** (`unreadCount`) : Suit le nombre de messages non lus
- **Équivalence** : Hérite d'`Equatable` pour faciliter les comparaisons d'objets

### Avantages de cette modélisation
- **Séparation claire** entre les conversations et les messages
- **Structure immuable** avec des champs finaux pour éviter les modifications accidentelles
- **Facilité de sérialisation/désérialisation** pour le stockage ou les API
- **Support de l'égalité structurelle** via Equatable pour les comparaisons et les tests

## Fonctionnalités

### 1. Liste des conversations
Affiche toutes les conversations avec les contacts, triées par date du dernier message.

```dart
Widget _buildConversationsList(List<Conversation> conversations) {
  return ListView.separated(
    itemCount: conversations.length,
    separatorBuilder: (context, index) => const Divider(),
    itemBuilder: (context, index) {
      final conversation = conversations[index];
      return _buildConversationTile(conversation);
    },
  );
}
```

**Caractéristiques principales :**
- Tri chronologique inversé (conversations les plus récentes en haut)
- Affichage du nombre de messages non lus
- Aperçu du dernier message
- Interface épurée avec séparateurs visuels

### 2. Détail d'une conversation
Affiche tous les messages échangés avec un contact spécifique.

```dart
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
```

**Caractéristiques principales :**
- Affichage chronologique des messages
- Gestion des conversations vides avec message explicatif
- Défilement fluide avec contrôleur dédié
- Mise en page adaptative avec padding approprié

### 3. Envoi de messages
Permet d'envoyer des messages textuels à un contact.

```dart
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
  elevation: 1,
  backgroundColor: Theme.of(context).primaryColor,
  child: const Icon(Icons.send, color: Colors.white, size: 20),
)
```

**Caractéristiques principales :**
- Validation du contenu avant envoi
- Intégration avec le système BLoC pour la gestion d'état
- Retour visuel immédiat (effacement du champ de saisie)
- Simulation de réponse pour démonstration
- Interface intuitive avec bouton d'envoi

### 4. Création de nouvelles conversations
Permet à l'utilisateur d'initier une nouvelle conversation avec un contact.

**Caractéristiques principales :**
- Interface modale pour la saisie du nom du contact
- Validation des entrées utilisateur
- Création immédiate de la conversation
- Redirection vers l'écran de détail de la nouvelle conversation

## Interface Utilisateur

### Écran de liste des conversations
- Affiche les conversations récentes
- Indique le nombre de messages non lus
- Affiche l'heure du dernier message
- Utilise des avatars pour identifier les contacts
- Bouton d'action flottant pour créer une nouvelle conversation

### Écran de détail d'une conversation
- Affiche les messages sous forme de bulles
- Différencie visuellement les messages envoyés et reçus
- Affiche l'heure d'envoi de chaque message
- Barre de saisie intuitive avec bouton d'envoi
- Retour visuel lors de l'envoi et la réception de messages

```dart
Widget _buildMessageBubble(Message message) {
  final isMe = message.isMe;
  final dateFormat = DateFormat.Hm();
  final bubbleColor = isMe ? Theme.of(context).primaryColor : Colors.grey[200];
  final textColor = isMe ? Colors.white : Colors.black87;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe)
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue[100],
            child: Text(
              widget.contactName[0].toUpperCase(),
              style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
            ),
          ),
        // ... contenu du message
      ],
    ),
  );
}
```

## Logique de l'application

### Gestion de l'état avec BLoC
L'application utilise le pattern BLoC pour gérer l'état de l'application de manière réactive.

```dart
class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc() : super(ConversationsLoading()) {
    on<LoadConversations>(_onLoadConversations);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  // Gestionnaires d'événements
  Future<void> _onLoadConversations(
      LoadConversations event, Emitter<ConversationState> emit) async {
    try {
      // Simulation d'un délai réseau
      await Future.delayed(const Duration(milliseconds: 500));
      emit(ConversationsLoaded(mockConversations));
    } catch (e) {
      emit(ConversationError(e.toString()));
    }
  }
  
  // ... autres gestionnaires
}
```

### Événements et états
Les interactions utilisateur sont transformées en événements qui sont traités par le BLoC pour produire de nouveaux états.

```dart
// Événements
abstract class ConversationEvent {}

class LoadConversations extends ConversationEvent {}
class LoadMessages extends ConversationEvent {
  final String conversationId;
  LoadMessages(this.conversationId);
}
class SendMessage extends ConversationEvent {
  final String conversationId;
  final String content;
  SendMessage(this.conversationId, this.content);
}

// États
abstract class ConversationState {}

class ConversationsLoading extends ConversationState {}
class ConversationsLoaded extends ConversationState {
  final List<Conversation> conversations;
  ConversationsLoaded(this.conversations);
}
class MessagesLoaded extends ConversationState {
  final String conversationId;
  final List<Message> messages;
  MessagesLoaded(this.conversationId, this.messages);
}
```

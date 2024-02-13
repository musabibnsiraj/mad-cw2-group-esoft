import 'package:my_office_chat/constant.dart';
import 'package:my_office_chat/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../main.dart';
import '../widgets/avatar.dart';
import '../widgets/message_bubble.dart';
import '../env/env.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.participantId});

  final String participantId;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final messageController = TextEditingController();
  final List<Message> messages = [];

  final chatRoom = ChatRoom(
    id: '8d162274-6cb8-4776-815a-8e721ebfb76d',
    users: const [
      User(
        id: '2e1b90e6-1750-4be0-b7b6-df04c7e611b7',
        username: 'Musab',
        phone: '0755513162',
        email: 'musab@gmail.com',
        avatarUrl: 'https://avatars.githubusercontent.com/u/47845204?v=4',
        status: 'online',
      ),
      User(
        id: 'df7a1235-d004-4b2b-8406-369c6ecfb050',
        username: 'Arsath',
        phone: '0755555555',
        email: 'arsath@gmail.com',
        avatarUrl:
            'https://static.vecteezy.com/system/resources/previews/008/442/086/non_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg',
        status: 'online',
      ),
    ],
    lastMessage: Message(
      id: 'de120f3a-dbca-4330-9e2e-18b55a2fb9e5',
      chatRoomId: '8d162274-6cb8-4776-815a-8e721ebfb76d',
      senderUserId: '2e1b90e6-1750-4be0-b7b6-df04c7e611b7',
      receiverUserId: 'df7a1235-d004-4b2b-8406-369c6ecfb050',
      content: 'Hi',
      createdAt: DateTime(2023, 12, 1, 1, 0, 0),
    ),
    unreadCount: 0,
  );

  @override
  void initState() {
    _loadMessages();
    _startWebSocket();

    messageRepository.subscribeToMessageUpdates((messageData) {
      final message = Message.fromJson(messageData);
      if (message.chatRoomId == chatRoom.id) {
        messages.add(message);
        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final message = Message(
      chatRoomId: chatRoom.id,
      senderUserId: userId1,
      receiverUserId: userId2,
      content: messageController.text,
      createdAt: DateTime.now(),
    );

    await messageRepository.createMessage(message);
    messageController.clear();
  }

  _loadMessages() async {
    final _messages = await messageRepository.fetchMessages(chatRoom.id);
    _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    setState(() {
      messages.addAll(_messages);
    });
  }

  _startWebSocket() {
    final apiBaseUrl = Env.API_BASE_URL;
    webSocketClient.connect(
      'ws://$apiBaseUrl/ws',
      {
        'Authorization': 'Bearer ....',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final currentParticipant = chatRoom.users.firstWhere(
      (user) => user.id == userId1,
    );

    final otherParticipant = chatRoom.users.firstWhere(
      (user) => user.id != currentParticipant.id,
    );

    return Scaffold(
      appBar: appBar(otherParticipant.username, elevation: 1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 8.0,
            bottom: (viewInsets.bottom > 0) ? 8.0 : 0.0,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];

                    final showImage = index + 1 == messages.length ||
                        messages[index + 1].senderUserId !=
                            message.senderUserId;

                    return Row(
                      mainAxisAlignment: (message.senderUserId != userId1)
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        MessageBubble(message: message),
                        if (showImage && message.senderUserId != userId1)
                          Avatar(
                            imageUrl: otherParticipant.avatarUrl,
                            radius: 12,
                          ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(color: appWhite),
                      controller: messageController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(100),
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _sendMessage();
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15)
            ],
          ),
        ),
      ),
    );
  }
}

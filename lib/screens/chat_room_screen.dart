// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:my_office_chat/constant.dart';
import 'package:my_office_chat/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../env/env.dart';
import '../main.dart';
import '../widgets/avatar.dart';
import '../widgets/message_bubble.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.chatRoom});

  final ChatRoom chatRoom;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final messageController = TextEditingController();
  final List<Message> messages = [];
  String logedUserId = '';

  @override
  void initState() {
    _init();
    _loadMessages();
    _startWebSocket();

    messageRepository.subscribeToMessageUpdates((messageData) {
      final message = Message.fromJson(messageData);
      if (message.chatRoomId == widget.chatRoom.id) {
        messages.add(message);
        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        setState(() {});
      }
    });
    super.initState();
  }

  _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    setState(() => logedUserId = userId);
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final message = Message(
      chatRoomId: widget.chatRoom.id,
      senderUserId: logedUserId,
      receiverUserId: logedUserId,
      content: messageController.text,
      createdAt: DateTime.now(),
    );

    await messageRepository.createMessage(message);
    messageController.clear();
  }

  _loadMessages() async {
    final _messages = await messageRepository.fetchMessages(widget.chatRoom.id);
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
    final currentParticipant = widget.chatRoom.users.firstWhere(
      (user) => user.id == logedUserId,
    );

    final otherParticipant = widget.chatRoom.users.firstWhere(
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
                        mainAxisAlignment: (message.senderUserId != logedUserId)
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          MessageBubble(
                            message: message,
                            logedUserId: logedUserId,
                          ),
                          if (showImage && message.senderUserId != logedUserId)
                            Avatar(
                              imageUrl: otherParticipant.avatarUrl,
                              radius: 12,
                            ),
                        ],
                      );
                    }),
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
                          icon: Icon(
                            Icons.send,
                            color: appWhite,
                          ),
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

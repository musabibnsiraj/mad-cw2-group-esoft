import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'repositories/message_repository.dart';
import 'screens/chat_room_screen.dart';
import 'services/api_client.dart';
import 'services/web_socket_client.dart';

final apiClient = ApiClient(tokenProvider: () async {
  // TODO: Get the bearer token of the current user.
  return '';
});

final webSocketClient = WebSocketClient();

final messageRepository = MessageRepository(
  apiClient: apiClient,
  webSocketClient: webSocketClient,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChatRoomScreen(chatRoom: chatRoom),
    );
  }
}

const userId1 = 'df7a1235-d004-4b2b-8406-369c6ecfb050';
const userId2 = '2e1b90e6-1750-4be0-b7b6-df04c7e611b7';

final chatRoom = ChatRoom(
  id: '8d162274-6cb8-4776-815a-8e721ebfb76d',
  participants: const [
    User(
      id: userId1,
      username: 'Musab',
      phone: '0755513162',
      email: 'musab@gmail.com',
      avatarUrl: 'https://avatars.githubusercontent.com/u/47845204?v=4',
      status: 'online',
    ),
    User(
      id: userId2,
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
    senderUserId: userId1,
    receiverUserId: userId2,
    content: 'Hi',
    createdAt: DateTime(2023, 12, 1, 1, 0, 0),
  ),
  unreadCount: 0,
);

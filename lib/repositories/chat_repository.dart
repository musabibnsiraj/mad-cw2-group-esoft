import 'dart:async';
import 'package:models/models.dart';

import '../services/api_client.dart';
import '../services/web_socket_client.dart';

class ChatRepository {
  final ApiClient apiClient;
  final WebSocketClient webSocketClient;

  ChatRepository({
    required this.apiClient,
    required this.webSocketClient,
  });

  Future<List<ChatRoom>> fetchChatsByUserId(String userId) async {
    final response = await apiClient.fetchChats(userId);
    final chatRooms = response['chats']
        .map<ChatRoom>((chatRoom) => ChatRoom.fromJson(chatRoom))
        .toList();

    return chatRooms;
  }
}

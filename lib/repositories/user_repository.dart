import 'dart:async';
import 'package:models/models.dart';

import '../services/api_client.dart';
import '../services/web_socket_client.dart';

class UserRepository {
  final ApiClient apiClient;
  final WebSocketClient webSocketClient;

  UserRepository({
    required this.apiClient,
    required this.webSocketClient,
  });

  Future<List<User>> fetchUsers() async {
    final response = await apiClient.fetchUsers();
    final users =
        response['users'].map<User>((user) => User.fromJson(user)).toList();

    return users;
  }
}

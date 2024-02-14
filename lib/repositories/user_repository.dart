import 'dart:async';
import 'package:models/models.dart';
import 'package:my_office_chat/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';
import '../services/api_client.dart';
import '../services/web_socket_client.dart';

class UserRepository {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final ApiClient apiClient;
  final WebSocketClient webSocketClient;

  UserRepository({
    required this.apiClient,
    required this.webSocketClient,
  });

  Future<List<User2>> fetchUsers() async {
    final response = await apiClient.fetchUsers();
    final users =
        response['users'].map<User2>((user) => User2.fromJson(user)).toList();

    return users;
  }

  Future<AuthResponse> signInWithEmail(email, password) async {
    try {
      final SharedPreferences prefs = await _prefs;
      final AuthResponse res = await supabase.auth
          .signInWithPassword(email: email, password: password);

      String userId = res.user!.id;
      if (userId.isNotEmpty) prefs.setString('userId', userId);

      return res;
    } catch (e) {
      rethrow;
    }
  }
}

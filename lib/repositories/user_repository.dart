import 'dart:async';
import 'package:models/models.dart';
import 'package:my_office_chat/main.dart';
// import 'package:supabase/supabase.dart';
import 'package:supabase/supabase.dart';
import '../services/api_client.dart';
import '../services/web_socket_client.dart';

// final supabaseClient = SupabaseClient(
//   'https://fklsmosyjsilrovygvij.supabase.co',
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZrbHNtb3N5anNpbHJvdnlndmlqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcwNzY3ODU0NywiZXhwIjoyMDIzMjU0NTQ3fQ.WvGvqZUieZgij-Wcv8UHXGwfhDlWkSF_pp31HaX9-rY',
// );

class UserRepository {
  final ApiClient apiClient;
  final WebSocketClient webSocketClient;

  UserRepository({
    required this.apiClient,
    required this.webSocketClient,
  });

  Future<List<User2>> fetchUsers() async {
    final response = await apiClient.fetchUsers();
    final users =
        response['users'].map<User>((user) => User.fromJson(user)).toList();

    return users;
  }

  Future<AuthResponse> signInWithEmail(email, password) async {
    try {
      final AuthResponse res = await supabase.auth
          .signInWithPassword(email: email, password: password);
      return res;
    } catch (e) {
      print('Authentication error: $e');
      rethrow;
    }
  }
}

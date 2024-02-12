import 'package:supabase/supabase.dart';

class UserRepository {
  final SupabaseClient dbClient;

  const UserRepository({required this.dbClient});

  Future<Map<String, dynamic>> createMessage(Map<String, dynamic> data) async {
    try {
      return await dbClient.from('users').insert(data).select().single();
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<List<Map<String, dynamic>>> fetchMessages(String chatRoomId) async {
    try {
      final messages = await dbClient.from('users').select<PostgrestList>();

      return messages;
    } catch (err) {
      throw Exception(err);
    }
  }
}

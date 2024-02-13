import 'package:supabase/supabase.dart';

class ChatRepository {
  final SupabaseClient dbClient;

  const ChatRepository({required this.dbClient});

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final users = await dbClient.from('users').select<PostgrestList>();
      return users;
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<dynamic> getChatRoomsWithUsers(String userId) async {
    try {
      final chatRoomResponse = await dbClient
          .from('chat_room_participants')
          .select<PostgrestList>('chat_room_id')
          .eq('participant_id', userId);

      final chatRoomIds =
          chatRoomResponse.map((chatRoom) => chatRoom['chat_room_id']).toList();

      // Fetch chat room details along with participants
      final chatRoomsResponse = await dbClient
          .from('chat_rooms')
          .select('*, chat_room_participants(*), users(*), messages(*)')
          .in_('id', chatRoomIds);

      return chatRoomsResponse;
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}

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

  Future<dynamic> getChatRoomIdWithBothParticipants(
    String loggedUserId,
    String contactUserId,
  ) async {
    try {
      final result = await dbClient
          .from('chat_room_participants')
          .select('chat_room_id')
          .in_('participant_id', [loggedUserId, contactUserId]);

      // Create an empty Set to store unique chat room IDs
      Set<String> uniqueChatRoomIds = {};
      var chat_room_id = null;
      // Iterate through the data and update the Set
      for (var item in result) {
        String chatRoomId = item['chat_room_id'];
        if (!uniqueChatRoomIds.add(chatRoomId)) {
          chat_room_id = chatRoomId;
        }
      }

      if (chat_room_id == null) {
        if (chat_room_id == null) {
          // Insert a new row into the 'chat_rooms' table
          var chat_room = await dbClient
              .from('chat_rooms')
              .insert({'last_message_id': null, 'unread_count': 0})
              .select()
              .single();

          chat_room_id = chat_room['id'];

          // Insert a new row into the 'chat_room_participants' table
          await dbClient.from('chat_room_participants').insert(
              {'participant_id': loggedUserId, 'chat_room_id': chat_room_id});

          await dbClient.from('chat_room_participants').insert(
              {'participant_id': contactUserId, 'chat_room_id': chat_room_id});
        }
      }

      // Fetch chat room details along with participants
      final chatRoomsResponse = await dbClient
          .from('chat_rooms')
          .select('*, chat_room_participants(*), users(*), messages(*)')
          .eq('id', chat_room_id)
          .single();

      return chatRoomsResponse;
    } catch (error) {
      rethrow; // Propagate the error for proper handling
    }
  }
}

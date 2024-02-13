import 'package:supabase/supabase.dart';

class UserRepository {
  final SupabaseClient dbClient;

  const UserRepository({required this.dbClient});

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
          .select('*, chat_room_participants(*), users(*)')
          .in_('id', chatRoomIds);

      return chatRoomsResponse;

      // // Step 1: Retrieve chat room IDs where the logged user is a participant
      // final chatRoomIdsResponse = await dbClient
      //     .from('chat_room_participants')
      //     .select('chat_room_id')
      //     .eq('participant_id', userId)
      //     .execute();

      // print('________________________________');
      // print(chatRoomIdsResponse);
      // print('_____________++++++++++++++++___________________');

      // // if (chatRoomIdsResponse.error != null) {
      // //   throw Exception(chatRoomIdsResponse.error!.message);
      // // }

      // final List<String> chatRoomIds = (chatRoomIdsResponse.data as List)
      //     .map((e) => e['chat_room_id'].toString())
      //     .toList();

      // // Step 2: Retrieve chat rooms with details of the opposite participant user
      // final List<Map<String, dynamic>> chatRooms = [];

      // for (final chatRoomId in chatRoomIds) {
      //   final chatRoomResponse = await dbClient
      //       .from('chat_rooms')
      //       .select('chat_rooms.*')
      //       .eq('id', chatRoomId)
      //       .single()
      //       .execute();

      //   // if (chatRoomResponse.error != null) {
      //   //   throw Exception(chatRoomResponse.error!.message);
      //   // }

      //   final chatRoom = chatRoomResponse.data as Map<String, dynamic>;

      //   final participantResponse = await dbClient
      //       .from('chat_room_participants')
      //       .select('participant_id')
      //       .eq('chat_room_id', chatRoomId)
      //       .execute();

      //   // if (participantResponse.error != null) {
      //   //   throw Exception(participantResponse.error!.message);
      //   // }

      //   final List<dynamic> participants = participantResponse.data ?? [];
      //   final oppositeParticipantId =
      //       participants.firstWhere((p) => p != userId);

      //   final oppositeParticipantUserResponse = await dbClient
      //       .from('users')
      //       .select('users.*')
      //       .eq('id', oppositeParticipantId)
      //       .single()
      //       .execute();

      //   // if (oppositeParticipantUserResponse.error != null) {
      //   //   throw Exception(oppositeParticipantUserResponse.error!.message);
      //   // }

      //   final oppositeParticipantUser =
      //       oppositeParticipantUserResponse.data as Map<String, dynamic>;

      //   chatRoom['oppositeParticipant'] = oppositeParticipantUser;

      //   chatRooms.add(chatRoom);
      // }

      // return chatRooms;
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}

import 'package:supabase/supabase.dart';

class UserRepository {
  final SupabaseClient dbClient;

  const UserRepository({required this.dbClient});

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final users = await dbClient.from('users').select<PostgrestList>();
      print(users);
      return users;
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<Map<String, dynamic>> addUser(Map<String, dynamic> data) async {
    try {
      return await dbClient.from('users').insert(data).select().single();
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<Map<String, dynamic>> updateUser(
      String id, Map<String, dynamic> data) async {
    try {
      return await dbClient
          .from('users')
          .update(data)
          .eq('id', id)
          .select()
          .single();
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await dbClient.from('users').delete().eq('id', id).execute();
    } catch (err) {
      throw Exception(err);
    }
  }
}

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
}

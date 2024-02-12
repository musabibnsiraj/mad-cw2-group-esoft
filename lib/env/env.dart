import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField()
  static String SUPABASE_URL = _Env.SUPABASE_URL;

  @EnviedField()
  static String SUPABASE_ANON_KEY = _Env.SUPABASE_ANON_KEY;

  @EnviedField()
  static String API_BASE_URL = _Env.API_BASE_URL;
}

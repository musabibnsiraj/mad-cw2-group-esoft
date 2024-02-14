import 'package:my_office_chat/repositories/chat_repository.dart';
import 'package:my_office_chat/repositories/user_repository.dart';
import 'package:my_office_chat/screens/chats.dart';
import 'package:flutter/material.dart';
import 'package:my_office_chat/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'repositories/message_repository.dart';
import 'services/api_client.dart';
import 'services/web_socket_client.dart';
import '../constant.dart';
import 'package:supabase/supabase.dart';

final apiClient = ApiClient(tokenProvider: () async {
  // TODO: Get the bearer token of the current user.
  return '';
});

//TODO:
const logedUserId = '2e1b90e6-1750-4be0-b7b6-df04c7e611b7';

final webSocketClient = WebSocketClient();

final messageRepository = MessageRepository(
  apiClient: apiClient,
  webSocketClient: webSocketClient,
);

// final supabaseClient = SupabaseClient(
//   'https://fklsmosyjsilrovygvij.supabase.co',
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZrbHNtb3N5anNpbHJvdnlndmlqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcwNzY3ODU0NywiZXhwIjoyMDIzMjU0NTQ3fQ.WvGvqZUieZgij-Wcv8UHXGwfhDlWkSF_pp31HaX9-rY',
// );

final userRepository = UserRepository(
  apiClient: apiClient,
  webSocketClient: webSocketClient,
);

final chatRepository = ChatRepository(
  apiClient: apiClient,
  webSocketClient: webSocketClient,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fklsmosyjsilrovygvij.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZrbHNtb3N5anNpbHJvdnlndmlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc2Nzg1NDcsImV4cCI6MjAyMzI1NDU0N30.7hPQ4qSf_SHw2Q3a0qbQQopjWUNMWMQNZTFcbfFfPcY',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Office',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor:
              Color.fromARGB(255, 3, 109, 72), // Change to your desired color
        ),
        unselectedWidgetColor: appWhite,
        iconTheme: IconThemeData(color: appIconColor),
        scaffoldBackgroundColor: appBgColor,
        textTheme: const TextTheme().copyWith(
          bodyMedium: TextStyle(color: appTextColor),
          displayLarge: TextStyle(color: appTextColor),
          displayMedium: TextStyle(color: appTextColor),
          titleMedium: TextStyle(color: appTextColor),
          titleSmall: TextStyle(color: appTextColor),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: appTextColor),
          hintStyle: TextStyle(color: appTextColor),
        ),
        primaryColor: primaryAppColor,
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: primaryColor, backgroundColor: primaryColor)
            .copyWith(background: appBgColor),
      ),
      debugShowCheckedModeBanner: false,
      home: const ChatsScreen(),
      // home: LoginScreen(userRepository: userRepository),
      routes: {
        '/chats': (context) => const ChatsScreen(),
      },
    );
  }
}

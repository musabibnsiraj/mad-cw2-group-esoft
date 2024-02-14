import 'package:my_office_chat/repositories/chat_repository.dart';
import 'package:my_office_chat/repositories/user_repository.dart';
import 'package:my_office_chat/screens/chats.dart';
import 'package:flutter/material.dart';
import 'package:my_office_chat/screens/login_screen.dart';
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

final supabaseClient = SupabaseClient(
  'https://fklsmosyjsilrovygvij.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZrbHNtb3N5anNpbHJvdnlndmlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc2Nzg1NDcsImV4cCI6MjAyMzI1NDU0N30.7hPQ4qSf_SHw2Q3a0qbQQopjWUNMWMQNZTFcbfFfPcY',
);

final userRepository = UserRepository(
  apiClient: apiClient,
  webSocketClient: webSocketClient,
);

final chatRepository = ChatRepository(
  apiClient: apiClient,
  webSocketClient: webSocketClient,
);

void main() {
  runApp(const MyApp());
}

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
      // home: const ChatsScreen(),//TEST
      home: LoginScreen(userRepository: userRepository),
      routes: {
        '/chats': (context) => const ChatsScreen(),
      },
    );
  }
}

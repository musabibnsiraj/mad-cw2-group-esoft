// ignore_for_file: library_private_types_in_public_api

import 'package:my_office_chat/repositories/chat_repository.dart';
import 'package:my_office_chat/repositories/user_repository.dart';
import 'package:my_office_chat/screens/chats.dart';
import 'package:flutter/material.dart';
import 'package:my_office_chat/screens/login_screen.dart';
import 'package:my_office_chat/widgets/common_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'repositories/message_repository.dart';
import 'services/api_client.dart';
import 'services/web_socket_client.dart';
import '../constant.dart';
import '../env/env.dart';

final apiClient = ApiClient(tokenProvider: () async {
  // TODO: Get the bearer token of the current user.
  return '';
});

final webSocketClient = WebSocketClient();

final messageRepository = MessageRepository(
  apiClient: apiClient,
  webSocketClient: webSocketClient,
);

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
    url: Env.SUPABASE_URL,
    anonKey: Env.SUPABASE_ANON_KEY,
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
      // home: const ChatsScreen(),//TEST
      home: const SplashScreen(),
      routes: {
        '/chats': (context) => const ChatsScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? logedUserId;

  @override
  void initState() {
    super.initState();
    checkLoggedInUser();
  }

  Future<void> checkLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    setState(() {
      logedUserId = userId;
    });

    if (logedUserId != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChatsScreen()),
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(userRepository: userRepository),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Spinner(),
      ),
    );
  }
}

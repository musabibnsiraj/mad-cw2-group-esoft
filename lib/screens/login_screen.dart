// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, no_logic_in_create_state, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_office_chat/repositories/user_repository.dart';
import 'package:my_office_chat/screens/chats.dart';
import 'package:models/models.dart';
import 'package:my_office_chat/widgets/common_widget.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository userRepository;

  const LoginScreen({Key? key, required this.userRepository}) : super(key: key);

  @override
  _LoginScreenState createState() =>
      _LoginScreenState(userRepository: userRepository);
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final UserRepository userRepository;
  late List<User2> users;
  bool isLoading = false;

  _LoginScreenState({required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Login'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _performLogin,
                child: isLoading
                    ? const CircularProgressIndicator() // Show loading indicator
                    : const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final String enteredEmail = _emailController.text;
      final String enteredPassword = _passwordController.text;

      await userRepository.signInWithEmail(enteredEmail, enteredPassword);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatsScreen(),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Incorrect email or password.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

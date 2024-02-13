// ignore_for_file: use_build_context_synchronously
import 'package:my_office_chat/widgets/user_input_widget.dart';

import '../../constant.dart';
// import '../../providers/user_provider.dart';
import '../../widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool loading = false;
  bool _isLoggedIn = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future loginCheck(
      dynamic usernameController, dynamic passwordController) async {
    setState(() => loading = true);
    try {
      String username = usernameController.text.toString();
      String password = passwordController.text.toString();

      final bool isValid = _formKey.currentState!.validate();
      if (isValid) {
        bool isLoggedIn = true; //TODO

        if (isLoggedIn) {
          setState(() => _isLoggedIn = true);
        }
      }
    } catch (e) {
      //
    } finally {
      setState(() => loading = false);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide the keyboard when tapping outside the input fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                const SizedBox(
                  height: 32,
                ),
                const FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Login to Your Account',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                UserFormInput(
                    showPrefixIcon: true,
                    textEditingControllerl: _usernameController,
                    textInputType: TextInputType.name,
                    hintText: 'Username',
                    inputIcon: Icons.person),
                const SizedBox(
                  height: 24,
                ),
                UserFormInput(
                    showPrefixIcon: true,
                    textEditingControllerl: _passwordController,
                    textInputType: TextInputType.text,
                    hintText: 'Password',
                    isPass: true,
                    inputIcon: Icons.lock),
                const SizedBox(
                  height: 24,
                ),
                const SizedBox(
                  height: 24,
                ),
                // InkWell(
                //   onTap: loading
                //       ? null
                //       : () async {
                //           await loginCheck(
                //               _usernameController, _passwordController);
                //           _isLoggedIn
                //               ? Navigator.of(context)
                //                   .push(MaterialPageRoute(builder: (context) {
                //                   return const MainDashboardScreen();
                //                 }))
                //               : null;
                //         },
                //   child: loading
                //       ? const Spinner()
                //       : const Buttonls(
                //           data: 'Login',
                //         ),
                // ),
                const SizedBox(
                  height: 50,
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text('Trouble logging in? Contact Support at'),
                //     Text(AppConfig.supportEmail,
                //         style: TextStyle(color: primaryAppColor)),
                //   ],
                // ),
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

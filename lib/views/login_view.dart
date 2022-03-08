import 'package:flutter/material.dart';
import 'package:noteefy/constants/routes.dart' show notesRoute, registerRoute, verifyEmailRoute;
import 'package:noteefy/exceptions/auth_exceptions.dart';
import 'package:noteefy/services/auth/auth_service.dart';
import 'package:noteefy/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter Your Email'),
          ),
          TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            controller: _password,
            decoration: const InputDecoration(
              hintText: 'Enter Your Password',
            ),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().logIn(email: email, password: password);
                  final user = AuthService.firebase().currentUser;
                  if(user?.isEmailVerified ?? false){
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (_) => false);
                  } else {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(verifyEmailRoute, (_) => false);
                  }
                } on UserNotFoundAuthException{
                  await showErrorDialog(context, 'User Not Found!');
                } on WrongPasswordAuthException{
                  await showErrorDialog(context, 'Wrong Credentials!');
                } on InvalidEmailAuthException{
                  await showErrorDialog(context, 'Invalid Email! Please Enter a valid Email');
                } on GenericAuthException{
                  await showErrorDialog(context, 'Authentication Error');
                }
              },
              child: const Text('Login')),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (_) => false);
            },
            child: const Text('Not Registered? Register Here'),
          )
        ],
      ),
    );
  }
}

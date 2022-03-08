import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteefy/constants/routes.dart' show notesRoute, registerRoute, verifyEmailRoute;
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
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password,);
                  final user = FirebaseAuth.instance.currentUser;
                  if(user?.emailVerified ?? false){
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (_) => false);
                  } else {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(verifyEmailRoute, (_) => false);
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    await showErrorDialog(context, 'User Not Found!');
                  } else if (e.code == 'wrong-password') {
                    await showErrorDialog(context, 'Wrong Credentials!');
                  } else if (e.code == 'invalid-email') {
                    await showErrorDialog(context, 'Invalid Email! Please Enter a valid Email');
                  }else {
                    await showErrorDialog(context, 'Error: ${e.code}');
                  }
                } catch (e) {
                  await showErrorDialog(context, e.toString());
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

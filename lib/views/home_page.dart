
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteefy/views/login_view.dart';
import 'package:noteefy/views/verify_email_view.dart';

import '../firebase_options.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          final user = FirebaseAuth.instance.currentUser;
          if(user != null){
            if(user.emailVerified){
              print('Email is Verified');
            } else {
              return const VerifyEmailView();
            }
          } else {
            return const LoginView();
          }
          return const Text('Done!');
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

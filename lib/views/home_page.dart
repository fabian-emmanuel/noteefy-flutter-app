import 'package:flutter/material.dart';
import 'package:noteefy/services/auth/auth_service.dart';
import 'package:noteefy/views/login_view.dart';
import 'package:noteefy/views/notes/notes_view.dart';
import 'package:noteefy/views/verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          final user = AuthService.firebase().currentUser;
          if(user != null){
            if(user.isEmailVerified){
              return const NotesView();
            } else {
              return const VerifyEmailView();
            }
          } else {
            return const LoginView();
          }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

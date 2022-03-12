

import 'package:flutter/material.dart';
import 'package:noteefy/constants/routes.dart';
import 'package:noteefy/views/home_page.dart';
import 'package:noteefy/views/login_view.dart';
import 'package:noteefy/views/my_home_page.dart';
import 'package:noteefy/views/notes/create_update_note_view.dart';
import 'package:noteefy/views/notes/notes_view.dart';
import 'package:noteefy/views/register_view.dart';
import 'package:noteefy/views/verify_email_view.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Noteefy',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const MyHomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      homeRoute: (context) => const HomePage(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      notesRoute: (context) => const NotesView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView()
    },
  ));
}



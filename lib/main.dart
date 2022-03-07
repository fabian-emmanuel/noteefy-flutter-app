

import 'package:flutter/material.dart';
import 'package:noteefy/views/home_page.dart';
import 'package:noteefy/views/login_view.dart';
import 'package:noteefy/views/notes_view.dart';
import 'package:noteefy/views/register_view.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Noteefy',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/notes/': (context) => const NotesView()
    },
  ));
}



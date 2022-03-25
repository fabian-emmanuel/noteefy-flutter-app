import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteefy/constants/routes.dart';
import 'package:noteefy/services/auth/bloc/auth_bloc.dart';
import 'package:noteefy/services/auth/firebase/firebase_auth_provider.dart';
import 'package:noteefy/views/home_page.dart';
import 'package:noteefy/views/notes/create_update_note_view.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MaterialApp(
    title: 'Noteefy',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage()),
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView()
    },
  ));
}



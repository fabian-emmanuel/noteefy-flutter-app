import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteefy/extensions/buildcontext/loc.dart';
import 'package:noteefy/services/auth/bloc/auth_bloc.dart';
import 'package:noteefy/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.verify_email),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                    context.loc.verify_email_view_prompt),
              ),
              TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(const AuthEventSendVerificationEmail());
                },
                child: Text(context.loc.verify_email_send_email_verification),
              ),
              TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(const AuthEventLogout());
                },
                child: Text(context.loc.already_verified_login_here),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

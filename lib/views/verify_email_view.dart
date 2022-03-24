import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              "We've just sent you an email for verification! Please open it to verify your email."),
          const Text("Didn't get any email? Click the link Below."),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(const AuthEventSendVerificationEmail());
            },
            child: const Text('Send Email Verification'),
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(const AuthEventLogout());
            },
            child: const Text('Already Verified? Login Here'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:noteefy/constants/routes.dart';
import 'package:noteefy/services/auth/auth_service.dart';

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
              await AuthService.firebase().sendVerificationEmail();
            },
            child: const Text('Send Email Verification'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (_) => false);
            },
            child: const Text('Already Verified? Login Here'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (_) => false);
            },
            child: const Text('Back to Register Page'),
          ),
        ],
      ),
    );
  }
}

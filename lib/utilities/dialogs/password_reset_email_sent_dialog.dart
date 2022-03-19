import 'package:flutter/material.dart';
import 'package:noteefy/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content: 'password reset sent! Please check your email!',
    optionsBuilder: () => {
      'ok': null,
    },
  );
}
import 'package:flutter/material.dart';
import 'package:noteefy/extensions/buildcontext/loc.dart';
import 'package:noteefy/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: context.loc.logout_button,
    content: context.loc.logout_dialog_prompt,
    optionsBuilder: () => {
      context.loc.no: false,
      context.loc.yes: true,
    },
  ).then((value) => value ?? false);
}

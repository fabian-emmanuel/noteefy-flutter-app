import 'package:flutter/material.dart';
import 'package:noteefy/extensions/buildcontext/loc.dart';
import 'package:noteefy/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: context.loc.delete,
    content: context.loc.delete_note_prompt,
    optionsBuilder: () => {
      context.loc.no: false,
      context.loc.yes: true,
    },
  ).then((value) => value ?? false);
}

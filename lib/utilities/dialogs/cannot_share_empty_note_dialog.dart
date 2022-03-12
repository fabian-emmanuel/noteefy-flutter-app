import 'package:flutter/material.dart';
import 'package:noteefy/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'Cannot share Empty Note',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
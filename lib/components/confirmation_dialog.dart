import 'package:flutter/material.dart';

typedef ConfirmationCallback = void Function(bool confirmed);

class ConfirmationDialog extends StatelessWidget {
  final ConfirmationCallback onConfirm;
  final ConfirmationCallback onCancel;

  const ConfirmationDialog(
      {super.key, required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm(true);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;
  final String? title;

  const ConfirmDialog({super.key, required this.message, this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? "Confirmação"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancelar"),
        ),
        TextButton(
          child: const Text("Confirmar"),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

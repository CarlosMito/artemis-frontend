import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;
  final String? title;

  const ConfirmDialog({super.key, required this.message, this.title});

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
          Navigator.of(context).pop(true);
        }
      },
      child: AlertDialog(
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
      ),
    );
  }
}

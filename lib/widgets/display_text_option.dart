import 'package:flutter/material.dart';

class DisplayTextOption extends StatelessWidget {
  final String label;
  final String value;
  final double minWidth;

  const DisplayTextOption({super.key, required this.label, required this.value, required this.minWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontFamily: "Lexend"),
        ),
        const SizedBox(height: 8),
        FittedBox(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, strokeAlign: -8),
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 36, 34, 39),
              ),
              child: Text(
                value,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

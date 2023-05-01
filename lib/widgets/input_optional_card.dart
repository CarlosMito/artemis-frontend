import 'package:flutter/material.dart';

class InputOptionalCard extends StatelessWidget {
  final String title;
  final Widget child;

  const InputOptionalCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: "Lexend",
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 20.0),
          child
        ],
      ),
    );
  }
}

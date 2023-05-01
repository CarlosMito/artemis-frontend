import 'package:artemis/widgets/diamond_separator.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class InputImageCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double? width;

  const InputImageCard({super.key, required this.title, required this.child, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          DiamondSeparator(
            margin: const EdgeInsets.only(bottom: 16),
            widthFactor: 0.6,
            content: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: "Lexend",
                  fontSize: 26,
                ),
              ),
            ),
          ),
          child
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';

class InputCard extends StatefulWidget {
  final Widget child;
  final String title;
  final double width;

  const InputCard({super.key, required this.title, required this.width, required this.child});

  @override
  State<InputCard> createState() => _InputCardState();
}

class _InputCardState extends State<InputCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.transparent,
          border: Border.all(
            color: const Color.fromARGB(255, 13, 13, 16),
          ),
        ),
        child: Column(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: "Lexend",
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            widget.child
          ],
        ),
      ),
    );
  }
}

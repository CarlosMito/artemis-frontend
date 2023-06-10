import 'package:flutter/material.dart';

class InputTextCard extends StatefulWidget {
  final Widget child;
  final String title;
  final double width;

  const InputTextCard({super.key, required this.title, required this.width, required this.child});

  @override
  State<InputTextCard> createState() => _InputTextCardState();
}

class _InputTextCardState extends State<InputTextCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          border: Border.all(
            color: const Color.fromARGB(255, 13, 13, 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1.0,
              blurRadius: 2.0,
              offset: const Offset(3, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
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

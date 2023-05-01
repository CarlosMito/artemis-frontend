import 'package:flutter/material.dart';

class DisplayTextOption extends StatelessWidget {
  final String title;
  final String value;

  const DisplayTextOption({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        Text(value),
      ],
    );
  }
}

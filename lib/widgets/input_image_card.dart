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
          Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: math.pi / 4,
                    child: Container(
                      height: 5,
                      width: 5,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Transform.rotate(
                    angle: math.pi / 4,
                    child: Container(
                      height: 7,
                      width: 7,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: width == null ? 120 : 50,
                    height: 1,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 18),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: "Lexend",
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Container(
                    width: width == null ? 120 : 50,
                    height: 1,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Transform.rotate(
                    angle: math.pi / 4,
                    child: Container(
                      height: 7,
                      width: 7,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Transform.rotate(
                    angle: math.pi / 4,
                    child: Container(
                      height: 5,
                      width: 5,
                      color: Colors.black,
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 14),
          child
        ],
      ),
    );
  }
}

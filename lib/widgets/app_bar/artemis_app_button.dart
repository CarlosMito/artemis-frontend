import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class ArtemisAppButton extends StatelessWidget {
  final String text;
  final String route;
  final bool onFocus;

  const ArtemisAppButton({super.key, required this.text, required this.route, this.onFocus = false});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.vRouter.to(route);
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[300],
            fontFamily: "Lexend",
          ),
        ),
      ),
    );
  }
}

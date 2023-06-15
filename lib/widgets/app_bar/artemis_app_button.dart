import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class ArtemisAppButton extends StatelessWidget {
  final String text;
  final String route;
  final bool onFocus;
  final Function()? onTap;

  const ArtemisAppButton({super.key, required this.text, required this.route, this.onFocus = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap ??
            () {
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

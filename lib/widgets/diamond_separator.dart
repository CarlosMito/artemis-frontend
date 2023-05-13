import 'package:flutter/material.dart';

import 'dart:math' as math;

class DiamondSeparator extends StatelessWidget {
  final double? width;
  final double? spacing;
  final double? innerIconSize;
  final double? outerIconSize;
  final double? widthFactor;
  final Widget? content;
  final EdgeInsetsGeometry? margin;

  const DiamondSeparator({
    super.key,
    this.width,
    this.spacing,
    this.innerIconSize,
    this.outerIconSize,
    this.content,
    this.margin,
    this.widthFactor,
  });

  List<Widget> buildHalf(bool reverse) {
    List<Widget> half = [
      Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          height: outerIconSize ?? 5,
          width: outerIconSize ?? 5,
          color: Colors.black,
        ),
      ),
      SizedBox(width: spacing ?? 8),
      Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          height: innerIconSize ?? 7,
          width: innerIconSize ?? 7,
          color: Colors.black,
        ),
      ),
      SizedBox(width: spacing ?? 8),
      Expanded(
        child: Container(
          width: double.infinity,
          height: 1,
          color: Colors.black,
        ),
      ),
    ];

    return reverse ? List.from(half.reversed) : half;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Row(children: [
          ...buildHalf(false),
          content ?? const SizedBox.shrink(),
          ...buildHalf(true),
        ]),
      ),
    );
  }
}

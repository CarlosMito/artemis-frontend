import 'package:artemis/models/piece.dart';
import 'package:flutter/material.dart';

const double _kMinFlingVelocity = 800.0;

class GridPieceViewer extends StatefulWidget {
  const GridPieceViewer({Key? key, this.piece}) : super(key: key);

  final Piece? piece;

  @override
  State<GridPieceViewer> createState() => _GridPieceViewerState();
}

class _GridPieceViewerState extends State<GridPieceViewer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _flingAnimation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  late Offset _normalizedOffset;
  late double _previousScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)..addListener(_handleFlingAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
  Offset _clampOffset(Offset offset) {
    final Size size = context.size!;
    final Offset minOffset = Offset(size.width, size.height) * (1.0 - _scale);
    return Offset(
      offset.dx.clamp(minOffset.dx, 0.0),
      offset.dy.clamp(minOffset.dy, 0.0),
    );
  }

  void _handleFlingAnimation() {
    setState(() {
      _offset = _flingAnimation.value;
    });
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      _controller.stop();
    });
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 4.0);
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) {
      return;
    }
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size!).shortestSide;
    _flingAnimation = _controller.drive(Tween<Offset>(
      begin: _offset,
      end: _clampOffset(_offset + direction * distance),
    ));
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleOnScaleUpdate,
      onScaleEnd: _handleOnScaleEnd,
      child: ClipRect(
        child: Transform(
          transform: Matrix4.identity()
            ..translate(_offset.dx, _offset.dy)
            ..scale(_scale),
          child: Image.network(
            widget.piece!.source,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
import 'package:artemis/models/piece.dart';
import 'package:artemis/widgets/app_bar/artemis_app_bar.dart';
import 'package:artemis/widgets/custom/artemis_network_image.dart';
import 'package:flutter/material.dart';

class GridPieceViewer extends StatefulWidget {
  const GridPieceViewer({Key? key, required this.piece}) : super(key: key);

  final Piece piece;

  @override
  State<GridPieceViewer> createState() => _GridPieceViewerState();
}

class _GridPieceViewerState extends State<GridPieceViewer> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const ArtemisAppBar().preferredSize,
        child: const Hero(
          tag: ArtemisAppBar,
          child: ArtemisAppBar(),
        ),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Hero(
                  key: Key(widget.piece.source),
                  tag: widget.piece.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: ArtemisNetworkImage(
                      widget.piece.source,
                      progressColor: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

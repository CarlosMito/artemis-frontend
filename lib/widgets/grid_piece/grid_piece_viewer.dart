import 'package:artemis/models/piece.dart';
import 'package:artemis/widgets/app_bar/artemis_app_bar.dart';
import 'package:artemis/widgets/custom/artemis_network_image.dart';
import 'package:artemis/widgets/input_info_list_view.dart';
import 'package:flutter/material.dart';

class GridPieceViewer extends StatefulWidget {
  const GridPieceViewer({Key? key, required this.piece}) : super(key: key);

  final DisplayPiece piece;

  @override
  State<GridPieceViewer> createState() => _GridPieceViewerState();
}

class _GridPieceViewerState extends State<GridPieceViewer> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const ArtemisAppBar().preferredSize,
        child: const ArtemisAppBar(),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: Hero(
                        key: Key(widget.piece.image),
                        tag: widget.piece.id,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              color: Colors.black,
                              width: 5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: ArtemisNetworkImage(
                              widget.piece.image,
                              progressColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: InputInfoListView(input: widget.piece.input),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

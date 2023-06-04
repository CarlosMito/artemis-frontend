import 'package:artemis/models/piece.dart';
import 'package:artemis/widgets/custom/artemis_network_image.dart';
import 'package:flutter/material.dart';

import 'grid_piece_viewer.dart';

typedef BannerTapCallback = void Function(Piece piece);

class GridPieceItem extends StatefulWidget {
  final Piece piece;
  final BannerTapCallback onBannerTap;

  const GridPieceItem({super.key, required this.piece, required this.onBannerTap});

  @override
  State<GridPieceItem> createState() => _GridPieceItemState();
}

class _GridPieceItemState extends State<GridPieceItem> {
  bool _onHover = false;

  void showPhoto(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return GridPieceViewer(piece: widget.piece);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = GestureDetector(
      onTap: () {
        showPhoto(context);
      },
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Semantics(
              label: '${widget.piece.title} - ${widget.piece.caption}',
              child: Hero(
                key: Key(widget.piece.source),
                tag: widget.piece.id,
                child: ArtemisNetworkImage(
                  widget.piece.source,
                  progressColor: Colors.black,
                ),
              ),
            ),
          ),
          if (_onHover) Container(color: Colors.black.withOpacity(0.5)),
        ],
      ),
    );

    final IconData icon = widget.piece.isFavorite ? Icons.favorite : Icons.favorite_border;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _onHover = true;
        });
      },
      onExit: (_) {
        setState(() {
          _onHover = false;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: GridTile(
          header: Container(
            margin: const EdgeInsets.only(top: 6.0),
            child: _onHover
                ? GridTileBar(
                    title: const SizedBox.shrink(),
                    trailing: IconButton(
                      onPressed: () => widget.onBannerTap(widget.piece),
                      icon: Icon(icon, color: Colors.white),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          footer: _onHover
              ? Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    child: GridTileBar(
                      title: Text(
                        widget.piece.title!,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: "Lato",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Container(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          widget.piece.caption!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: "Lato",
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          child: image,
        ),
      ),
    );
  }
}

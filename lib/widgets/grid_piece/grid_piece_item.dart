import 'package:artemis/models/text2image/artemis_output_api.dart';
import 'package:artemis/widgets/custom/artemis_network_image.dart';
import 'package:flutter/material.dart';

import 'grid_piece_viewer.dart';

typedef BannerTapCallback = void Function(ArtemisOutputAPI piece);

class GridPieceItem extends StatefulWidget {
  final ArtemisOutputAPI outputPiece;
  final BannerTapCallback onBannerTap;

  const GridPieceItem({super.key, required this.outputPiece, required this.onBannerTap});

  @override
  State<GridPieceItem> createState() => _GridPieceItemState();
}

class _GridPieceItemState extends State<GridPieceItem> {
  bool _onHover = false;

  void showPhoto(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return GridPieceViewer(outputPiece: widget.outputPiece);
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
              label: '${widget.outputPiece.title} - ${widget.outputPiece.caption}',
              child: Hero(
                key: Key(widget.outputPiece.image),
                tag: widget.outputPiece.image,
                child: ArtemisNetworkImage(
                  widget.outputPiece.image,
                  progressColor: Colors.black,
                ),
              ),
            ),
          ),
          if (_onHover) Container(color: Colors.black.withOpacity(0.5)),
        ],
      ),
    );

    final IconData icon = widget.outputPiece.isFavorite ? Icons.favorite : Icons.favorite_border;

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
                    trailing: Tooltip(
                      message: "Favoritar",
                      waitDuration: const Duration(milliseconds: 650),
                      child: IconButton(
                        onPressed: () => widget.onBannerTap(widget.outputPiece),
                        icon: Icon(icon, color: Colors.white),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          footer: _onHover
              ? Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    child: GridTileBar(
                      title: Flexible(
                        child: Container(
                          padding: const EdgeInsets.only(right: 14.0),
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            widget.outputPiece.title!,
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      subtitle: Container(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          widget.outputPiece.caption!,
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

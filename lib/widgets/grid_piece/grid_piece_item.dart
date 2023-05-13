import 'package:artemis/models/piece.dart';
import 'package:flutter/material.dart';

import 'grid_piece_viewer.dart';

typedef BannerTapCallback = void Function(Piece piece);

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(text!),
    );
  }
}

class GridPieceItem extends StatelessWidget {
  const GridPieceItem({
    Key? key,
    required this.piece,
    required this.onBannerTap,
  }) : super(key: key);

  final Piece piece;
  final BannerTapCallback onBannerTap;

  void showPhoto(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(piece.title!),
        ),
        body: SizedBox.expand(
          child: Hero(
            tag: piece.id,
            child: GridPieceViewer(piece: piece),
          ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = Semantics(
      label: '${piece.title} - ${piece.caption}',
      child: GestureDetector(
        onTap: () {
          showPhoto(context);
        },
        child: Hero(
          key: Key(piece.source),
          tag: piece.id,
          child: Image.network(
            piece.source,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    final IconData icon = piece.isFavorite ? Icons.star : Icons.star_border;

    return GridTile(
      footer: GestureDetector(
        onTap: () {
          onBannerTap(piece);
        },
        child: GridTileBar(
          backgroundColor: Colors.black45,
          title: _GridTitleText(piece.title),
          subtitle: _GridTitleText(piece.caption),
          trailing: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
      child: image,
    );
  }
}

import 'package:artemis/models/piece.dart';
import 'package:artemis/utils/maps.dart';
import 'package:artemis/widgets/app_bar/artemis_app_bar.dart';
import 'package:artemis/widgets/grid_piece/grid_piece_item.dart';
import 'package:flutter/material.dart';

// https://github.com/flutter/flutter/blob/b8a2456737c9645e5f3d7210fba6267f7408486f/dev/integration_tests/flutter_gallery/lib/demo/material/grid_list_demo.dart

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Piece> pieces = <Piece>[];

  @override
  void initState() {
    super.initState();

    imageMapping.forEach((key, value) {
      if (key is int) {
        pieces.add(Piece(
          source: value,
          title: "Teste $key",
          caption: "@Legenda $key",
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const ArtemisAppBar().preferredSize,
        child: const Hero(
          tag: ArtemisAppBar,
          child: ArtemisAppBar(),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: GridView.count(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                padding: const EdgeInsets.all(10.0),
                childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
                children: pieces.map<Widget>((Piece piece) {
                  return GridPieceItem(
                    piece: piece,
                    onBannerTap: (Piece piece) {
                      setState(() {
                        piece.isFavorite = !piece.isFavorite;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

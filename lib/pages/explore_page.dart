import 'package:artemis/api/api_service.dart';
import 'package:artemis/models/text2image/artemis_output_api.dart';
import 'package:artemis/widgets/app_bar/artemis_app_bar.dart';
import 'package:artemis/widgets/grid_piece/grid_piece_item.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<ArtemisOutputAPI> publicOutputs = <ArtemisOutputAPI>[];

  @override
  void initState() {
    super.initState();
    _getPublicOutputs();
  }

  void _getPublicOutputs() async {
    var outputs = await ArtemisApiService.getPublicOutputs();

    for (var output in outputs) {
      output.title = output.input.prompt;
      output.caption = "@${output.input.user?.username}";
    }

    setState(() {
      publicOutputs = outputs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const ArtemisAppBar().preferredSize,
        child: ArtemisAppBar(onLogin: _getPublicOutputs, onLogout: _getPublicOutputs),
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
                children: publicOutputs.map<Widget>((ArtemisOutputAPI output) {
                  return GridPieceItem(
                    outputPiece: output,
                    onBannerTap: (ArtemisOutputAPI piece) {
                      ArtemisApiService.saveFavorite(piece.id);

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

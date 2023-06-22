import 'package:artemis/enums/image_dimension.dart';
import 'package:artemis/enums/image_saturation.dart';
import 'package:artemis/enums/image_style.dart';
import 'package:artemis/enums/image_value.dart';
import 'package:artemis/enums/scheduler.dart';
import 'package:artemis/models/piece.dart';
import 'package:artemis/models/text2image/artemis_input_api.dart';
import 'package:artemis/models/text2image/artemis_output_api.dart';
import 'package:artemis/models/user.dart';
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
  List<ArtemisOutputAPI> pieces = <ArtemisOutputAPI>[];

  @override
  void initState() {
    super.initState();

    imageMapping.forEach((key, value) {
      if (key is int) {
        pieces.add(ArtemisOutputAPI(
          image: value,
          title: "Teste $key",
          caption: "@Legenda $key",
          input: ArtemisInputAPI(
            userId: User(id: BigInt.from(1), username: "carlosmito", email: "carlosmito@email.com").id,
            prompt: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout."
                "The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using"
                "'Content here, content here', making it look like readable English.",
            negativePrompt: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form,"
                "by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum,"
                "you need to be sure there isn't anything embarrassing hidden in the middle of text.",
            guidanceScale: 9,
            imageDimensions: ImageDimensions.dim768,
            scheduler: Scheduler.kEuler,
            numInferenceSteps: 100,
            numOutputs: 3,
            seed: 384690124,
            style: ImageStyle.digitalArt,
            colorValue: Colors.amber.value,
            saturation: ImageSaturation.high,
            value: ImageValue.low,
          ),
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
        child: const ArtemisAppBar(),
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
                children: pieces.map<Widget>((ArtemisOutputAPI piece) {
                  return GridPieceItem(
                    outputPiece: piece,
                    onBannerTap: (ArtemisOutputAPI piece) {
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

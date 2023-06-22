import 'package:artemis/models/text2image/artemis_output_api.dart';
import 'package:artemis/utils/image_downloader.dart';
import 'package:artemis/widgets/app_bar/artemis_app_bar.dart';
import 'package:artemis/widgets/custom/artemis_network_image.dart';
import 'package:artemis/widgets/input_info_list_view.dart';
import 'package:flutter/material.dart';

class GridPieceViewer extends StatefulWidget {
  const GridPieceViewer({Key? key, required this.outputPiece}) : super(key: key);

  final ArtemisOutputAPI outputPiece;

  @override
  State<GridPieceViewer> createState() => _GridPieceViewerState();
}

class _GridPieceViewerState extends State<GridPieceViewer> with SingleTickerProviderStateMixin {
  Widget buildToolbar() {
    Duration defaultWaitDuration = const Duration(milliseconds: 650);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          preferBelow: true,
          waitDuration: defaultWaitDuration,
          message: "Baixar",
          child: IconButton(
            onPressed: () => downloadFileFromUrl(widget.outputPiece.image),
            icon: const Icon(Icons.download),
          ),
        ),
        Tooltip(
          preferBelow: true,
          waitDuration: defaultWaitDuration,
          message: "Compartilhar",
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
        ),
        Tooltip(
          preferBelow: true,
          waitDuration: defaultWaitDuration,
          message: "Favoritar",
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          ),
        ),
        Tooltip(
          preferBelow: true,
          waitDuration: defaultWaitDuration,
          message: "Recriar",
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }

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
                        key: Key(widget.outputPiece.image),
                        tag: widget.outputPiece.image,
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
                              widget.outputPiece.image,
                              progressColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildToolbar(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: InputInfoListView(input: widget.outputPiece.input),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:artemis/api/api_service.dart';
import 'package:artemis/models/text2image/artemis_input_api.dart';
import 'package:artemis/models/text2image/artemis_output_api.dart';
import 'package:artemis/utils/confirm_dialog.dart';
import 'package:artemis/utils/image_downloader.dart';
import 'package:artemis/widgets/custom/artemis_network_image.dart';
import 'package:artemis/widgets/input_info_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageVisualizer extends StatefulWidget {
  final List<List<ArtemisOutputAPI>> outputs;
  final int setIndex;
  final int imageIndex;

  const ImageVisualizer({super.key, required this.outputs, required this.setIndex, required this.imageIndex});

  @override
  State<ImageVisualizer> createState() => _ImageVisualizerState();
}

class _ImageVisualizerState extends State<ImageVisualizer> {
  late ArtemisInputAPI _input;
  late int _setIndex;
  late int _imageIndex;

  ArtemisOutputAPI get currentOutput => widget.outputs[_setIndex][_imageIndex];

  @override
  void initState() {
    super.initState();
    _setIndex = widget.setIndex;
    _imageIndex = widget.imageIndex;
    _input = widget.outputs[_setIndex][_imageIndex].input;
  }

  void previousImage() {
    if (_imageIndex > 0) {
      setState(() {
        _imageIndex -= 1;
      });
    } else if (_setIndex > 0) {
      setState(() {
        _setIndex -= 1;
        _imageIndex = widget.outputs[_setIndex].length - 1;
        _input = widget.outputs[_setIndex][_imageIndex].input;
      });
    }
  }

  void nextImage() {
    if (_imageIndex < widget.outputs[_setIndex].length - 1) {
      setState(() {
        _imageIndex += 1;
      });
    } else if (_setIndex < widget.outputs.length - 1) {
      setState(() {
        _imageIndex = 0;
        _setIndex += 1;
        _input = widget.outputs[_setIndex][_imageIndex].input;
      });
    }
  }

  Widget buildToolbar() {
    Duration defaultWaitDuration = const Duration(milliseconds: 650);

    return Row(
      children: [
        Tooltip(
          waitDuration: defaultWaitDuration,
          message: "Anterior",
          child: IconButton(
            onPressed: previousImage,
            icon: const Icon(Icons.keyboard_arrow_left),
          ),
        ),
        Tooltip(
          waitDuration: defaultWaitDuration,
          message: "Baixar",
          child: IconButton(
            onPressed: () => downloadFileFromUrl(currentOutput.image),
            icon: const Icon(Icons.download),
          ),
        ),
        // Tooltip(
        //   waitDuration: defaultWaitDuration,
        //   message: "Compartilhar",
        //   child: IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.share),
        //   ),
        // ),
        Tooltip(
          waitDuration: defaultWaitDuration,
          message: "Tornar Público",
          child: IconButton(
            onPressed: () async {
              bool? toPublic = true;

              if (!currentOutput.isPublic) {
                toPublic = await showDialog(
                  context: context,
                  builder: (context) => const ConfirmDialog(
                    title: "Tornar público?",
                    message: "Ao deixar esta obra pública,\ntoda a comunicadade poderá visualizá-la!",
                  ),
                );
              }

              if (toPublic != null && toPublic) {
                currentOutput.isPublic = !currentOutput.isPublic;
                await ArtemisApiService.updateOutputToPublic(currentOutput);
                setState(() {});
              }

              // var currentOutput = widget.outputs[_setIndex][_imageIndex];
              // ArtemisApiService.updateOutputToPublic(currentOutput);
            },
            icon: Icon(currentOutput.isPublic ? Icons.public : Icons.public_off),
          ),
        ),
        Tooltip(
          waitDuration: defaultWaitDuration,
          message: "Favoritar",
          child: IconButton(
            onPressed: () async {
              await ArtemisApiService.saveFavorite(currentOutput.id);

              setState(() {
                currentOutput.isFavorite = !currentOutput.isFavorite;
              });
            },
            icon: Icon(currentOutput.isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
        ),
        Tooltip(
          waitDuration: defaultWaitDuration,
          message: "Recriar",
          child: IconButton(
            onPressed: () async {
              bool? result = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const ConfirmDialog(
                    title: "Recriar obra?",
                    message: "Esta ação irá sobrescrever os campos\npreenchidos no momento!",
                  );
                },
              );

              if (result != null && result && context.mounted) {
                var currentOutput = widget.outputs[_setIndex][_imageIndex];
                Navigator.of(context).pop(currentOutput.input);
              }

              // var currentOutput = widget.outputs[_setIndex][_imageIndex];
              // Navigator.of(context).pop(currentOutput.input);
            },
            icon: const Icon(Icons.refresh),
          ),
        ),
        Tooltip(
          waitDuration: defaultWaitDuration,
          message: "Próximo",
          child: IconButton(
            onPressed: nextImage,
            icon: const Icon(
              Icons.keyboard_arrow_right,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBody() {
    return Row(
      children: [
        Column(
          children: [
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
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
                        widget.outputs[_setIndex][_imageIndex].image,
                        progressColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            buildToolbar(),
          ],
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 50),
                child: InputInfoListView(input: _input),
              ),
              Positioned(
                right: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          nextImage();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          previousImage();
        }
      },
      child: AlertDialog(
        content: AspectRatio(
          aspectRatio: 2,
          child: buildBody(),
        ),
      ),
    );
  }
}

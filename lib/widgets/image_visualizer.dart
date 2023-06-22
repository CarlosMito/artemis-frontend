import 'package:artemis/models/text2image/artemis_input_api.dart';
import 'package:artemis/models/text2image/artemis_output_api.dart';
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
    return Row(
      children: [
        IconButton(
          onPressed: previousImage,
          icon: const Icon(Icons.keyboard_arrow_left),
        ),
        IconButton(onPressed: () => downloadFileFromUrl(widget.outputs[_setIndex][_imageIndex].image), icon: const Icon(Icons.download)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
        IconButton(
          onPressed: nextImage,
          icon: const Icon(
            Icons.keyboard_arrow_right,
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
                    child: ArtemisNetworkImage(
                      widget.outputs[_setIndex][_imageIndex].image,
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

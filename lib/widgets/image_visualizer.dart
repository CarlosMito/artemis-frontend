import 'dart:developer';

import 'package:artemis/enums/image_dimension.dart';
import 'package:artemis/enums/image_style.dart';
import 'package:artemis/enums/scheduler.dart';
import 'package:artemis/models/output_api.dart';
import 'package:artemis/widgets/diamond_separator.dart';
import 'package:artemis/widgets/display_image_option.dart';
import 'package:artemis/widgets/display_text_option.dart';
import 'package:flutter/material.dart';

import '../enums/image_saturation.dart';
import '../enums/image_value.dart';
import '../models/input_api.dart';
import '../utils/maps.dart';

class ImageVisualizer extends StatefulWidget {
  final List<OutputAPI> outputs;
  final int setIndex;
  final int imageIndex;

  const ImageVisualizer({super.key, required this.outputs, required this.setIndex, required this.imageIndex});

  @override
  State<ImageVisualizer> createState() => _ImageVisualizerState();
}

class _ImageVisualizerState extends State<ImageVisualizer> {
  late InputAPI _input;
  late int _setIndex;
  late int _imageIndex;

  @override
  void initState() {
    super.initState();
    _setIndex = widget.setIndex;
    _imageIndex = widget.imageIndex;
    _input = widget.outputs[_setIndex].input;
  }

  List<DisplayImageOption> buildDisplayImageOptions() {
    List<DisplayImageOption> imageOptions = [];

    imageOptions.add(DisplayImageOption(label: colorMap[_input.color], color: _input.color));
    imageOptions.add(DisplayImageOption(label: _input.style?.toDisplay(), imageUrl: imagePlaceholders[_input.style]));
    imageOptions.add(DisplayImageOption(label: _input.saturation?.toDisplay(), imageUrl: imagePlaceholders[_input.saturation]));
    imageOptions.add(DisplayImageOption(label: _input.value?.toDisplay(), imageUrl: imagePlaceholders[_input.value]));

    return imageOptions;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: AspectRatio(
        aspectRatio: 2,
        child: Row(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: NetworkImage(widget.outputs[_setIndex].images[_imageIndex]),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                            color: Colors.black,
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_imageIndex > 0) {
                          setState(() {
                            _imageIndex -= 1;
                          });
                        } else if (_setIndex > 0) {
                          setState(() {
                            _setIndex -= 1;
                            _imageIndex = widget.outputs[_setIndex].images.length - 1;
                            _input = widget.outputs[_setIndex].input;
                          });
                        }
                      },
                      icon: const Icon(Icons.keyboard_arrow_left),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
                    IconButton(
                        onPressed: () {
                          if (_imageIndex < widget.outputs[_setIndex].images.length - 1) {
                            setState(() {
                              _imageIndex += 1;
                            });
                          } else if (_setIndex < widget.outputs.length - 1) {
                            setState(() {
                              _imageIndex = 0;
                              _setIndex += 1;
                              _input = widget.outputs[_setIndex].input;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_right,
                        )),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(28),
                    children: [
                      const DiamondSeparator(margin: EdgeInsets.symmetric(vertical: 10), widthFactor: 0.7),
                      const Center(
                        child: Text(
                          "Visualização",
                          style: TextStyle(fontFamily: "Lexend", fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const DiamondSeparator(margin: EdgeInsets.symmetric(vertical: 10), widthFactor: 0.7),
                      const SizedBox(height: 26),
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: const Text(
                          "Prompts",
                          style: TextStyle(
                            fontFamily: "Lexend",
                            fontSize: 26,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(children: const [
                              Flexible(
                                child: Text(
                                  "Prompt Positivo",
                                  style: TextStyle(
                                    fontFamily: "Lexend",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 10),
                            Text(
                              _input.prompt,
                              style: const TextStyle(fontFamily: "Lexend"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_input.negativePrompt != null)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(children: const [
                                Flexible(
                                  child: Text(
                                    "Prompt Negativo",
                                    style: TextStyle(
                                      fontFamily: "Lexend",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 10),
                              Text(
                                _input.negativePrompt!,
                                style: const TextStyle(fontFamily: "Lexend"),
                              ),
                            ],
                          ),
                        ),
                      const DiamondSeparator(margin: EdgeInsets.symmetric(vertical: 40), widthFactor: 0.5),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        runSpacing: 16,
                        children: [
                          DisplayTextOption(
                            label: "Tamanho",
                            minWidth: 150,
                            value: _input.imageDimensions.toReplicateAPI(),
                          ),
                          DisplayTextOption(
                            label: "Semente",
                            minWidth: 150,
                            value: _input.seed.toString(),
                          ),
                          DisplayTextOption(
                            label: "Inferências",
                            minWidth: 150,
                            value: _input.numInferenceSteps.toString(),
                          ),
                          DisplayTextOption(
                            label: "Escala de Orientação",
                            minWidth: 150,
                            value: _input.guidanceScale.toString(),
                          ),
                          DisplayTextOption(
                            label: "Agendador",
                            minWidth: 150,
                            value: _input.scheduler.toReplicateAPI(),
                          ),
                        ],
                      ),
                      const DiamondSeparator(margin: EdgeInsets.symmetric(vertical: 40), widthFactor: 0.5),
                      Wrap(
                        spacing: 10,
                        alignment: WrapAlignment.center,
                        children: buildDisplayImageOptions(),
                      )
                    ],
                  ),
                  Positioned(
                    right: 0,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

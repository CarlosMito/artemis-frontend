import 'dart:developer';

import 'package:artemis/enums/image_dimension.dart';
import 'package:artemis/enums/image_saturation.dart';
import 'package:artemis/enums/image_style.dart';
import 'package:artemis/enums/image_value.dart';
import 'package:artemis/models/input_api.dart';
import 'package:artemis/models/output_api.dart';
import 'package:artemis/enums/scheduler.dart';
import 'package:artemis/widgets/diamond_separator.dart';
import 'package:artemis/widgets/display_image_option.dart';
import 'package:artemis/widgets/image_visualizer.dart';
import 'package:artemis/widgets/radio_image_button.dart';
import 'package:artemis/widgets/radio_text_button.dart';
import 'package:artemis/widgets/display_text_option.dart';
import 'package:artemis/widgets/input_text_card.dart';
import 'package:artemis/widgets/input_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../api_service.dart';
import '../utils/maps.dart';

class CreationPage extends StatefulWidget {
  const CreationPage({super.key});

  @override
  State<CreationPage> createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  String _prompt = "";
  String _negativePrompt = "";
  String? _imageUrl;
  String? _id;
  String? _seed;

  final List<OutputAPI> _generations = [
    OutputAPI(
      input: InputAPI(
        prompt: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
      ),
    ),
    OutputAPI(
      input: InputAPI(
        prompt: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout."
            "The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using",
        guidanceScale: 1,
        imageDimensions: ImageDimensions.dim768,
        scheduler: Scheduler.klms,
        numOutputs: 2,
        seed: 100,
      ),
    ),
    OutputAPI(
      input: InputAPI(
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
        color: Colors.amber,
        saturation: ImageSaturation.high,
        value: ImageValue.low,
      ),
    ),
    OutputAPI(
      input: InputAPI(
        prompt: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
        numOutputs: 4,
        color: Colors.pink,
        value: ImageValue.low,
      ),
    ),
  ];

  final List<RadioModel> _imageDimensions = [];
  final List<RadioModel> _schedulers = [];
  final List<RadioModel> _numOutputs = [];
  final List<ImageRadioModel> _colors = [];
  final List<ImageRadioModel> _styles = [];
  final List<ImageRadioModel> _saturations = [];
  final List<ImageRadioModel> _values = [];

  void _postRequest() async {
    if (_prompt.isNotEmpty) {
      Map<String, dynamic>? res = await ApiService().postPrompt(_prompt);
      _id = res?["id"];

      // var results = res?["results"];
      // id = results?[0]["id"];

      // print(res.toString());
      log(_id ?? "Não foi possível gerar a imagem");
    }
    // Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void _getRequest() async {
    if (_id != null) {
      Map<String, dynamic>? res = await ApiService().getStatus(_id!);

      if (res != null) {
        log(res["status"]);

        if (res["status"] == "succeeded") {
          log(res["output"][0]);
          _imageUrl = res["output"][0];
          setState(() {});
        }

        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    for (var element in ImageDimensions.values) {
      _imageDimensions.add(RadioModel(false, element, element.toReplicateAPI()));
    }

    for (var element in Scheduler.values) {
      _schedulers.add(RadioModel(false, element, element.toReplicateAPI()));
    }

    for (int i = 1; i < 5; i++) {
      _numOutputs.add(RadioModel(false, i, i.toString()));
    }

    _styles.add(ImageRadioModel(true, label: "Aleatório", color: Colors.transparent));
    _colors.add(ImageRadioModel(true, label: "Aleatório", color: Colors.transparent));
    _saturations.add(ImageRadioModel(true, label: "Aleatório", color: Colors.transparent));
    _values.add(ImageRadioModel(true, label: "Aleatório", color: Colors.transparent));

    for (final mapEntry in colorMap.entries) {
      _colors.add(ImageRadioModel(
        false,
        label: mapEntry.value,
        color: mapEntry.key,
      ));
    }

    for (var style in ImageStyle.values) {
      _styles.add(ImageRadioModel(
        false,
        label: style.toDisplay(),
        imageUrl: imagePlaceholders[style],
      ));
    }

    for (var saturation in ImageSaturation.values) {
      _saturations.add(ImageRadioModel(
        false,
        label: saturation.toDisplay(),
        imageUrl: imagePlaceholders[saturation],
      ));
    }

    for (var value in ImageValue.values) {
      _values.add(ImageRadioModel(
        false,
        label: value.toDisplay(),
        imageUrl: imagePlaceholders[value],
      ));
    }

    _imageDimensions[0].isSelected = true;
    _schedulers[0].isSelected = true;
    _numOutputs[0].isSelected = true;

    //================
    // Init Outputs
    //================
    _generations[0].images = [
      imagePlaceholders[0]!,
    ];

    _generations[1].images = [
      imagePlaceholders[1]!,
      imagePlaceholders[2]!,
    ];

    _generations[2].images = [
      imagePlaceholders[3]!,
      imagePlaceholders[4]!,
      imagePlaceholders[5]!,
    ];

    _generations[3].images = [
      imagePlaceholders[2]!,
      imagePlaceholders[1]!,
      imagePlaceholders[4]!,
      imagePlaceholders[0]!,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artemis'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          for (RadioModel element in _imageDimensions) {
            if (element.isSelected) {
              log(element.value.toString());
            }
          }

          for (RadioModel element in _numOutputs) {
            if (element.isSelected) {
              log(element.value.toString());
            }
          }

          for (ImageRadioModel element in _styles) {
            if (element.isSelected) {
              log(element.label.toString());
            }
          }

          for (ImageRadioModel element in _colors) {
            if (element.isSelected) {
              log(element.label.toString());
            }
          }

          for (ImageRadioModel element in _saturations) {
            if (element.isSelected) {
              log(element.label.toString());
            }
          }

          for (ImageRadioModel element in _values) {
            if (element.isSelected) {
              log(element.label.toString());
            }
          }

          log(_seed ?? "[vazio]");

          showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return ImageVisualizer(output: _generations[0]);
            },
          );
        },
        label: const Text("Gerar"),
        icon: const Icon(Icons.send),
        backgroundColor: Colors.pink,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(40.0),
                children: [
                  Container(
                    margin: const EdgeInsets.all(50),
                    alignment: Alignment.center,
                    child: const Text(
                      "Texto à Imagem",
                      style: TextStyle(
                        fontFamily: "Lexend",
                        fontSize: 46,
                      ),
                    ),
                  ),
                  const Text(
                    "Prompts",
                    style: TextStyle(
                      fontFamily: "Lexend",
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  TextField(
                    onChanged: (String text) {
                      _prompt = text;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Descreva o que você quer gerar",
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  TextField(
                    onChanged: (String text) {
                      _negativePrompt = text;
                    },
                    style: const TextStyle(color: Color.fromARGB(255, 240, 240, 240)),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Descreva o que você não quer ver na imagem",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 180, 180, 180)),
                        fillColor: Color.fromARGB(255, 13, 13, 16),
                        filled: true),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 80),
                      Transform.rotate(
                        angle: math.pi / 4,
                        child: Container(
                          height: 5,
                          width: 5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Transform.rotate(
                        angle: math.pi / 4,
                        child: Container(
                          height: 7,
                          width: 7,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Transform.rotate(
                        angle: math.pi / 4,
                        child: Container(
                          height: 7,
                          width: 7,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Transform.rotate(
                        angle: math.pi / 4,
                        child: Container(
                          height: 5,
                          width: 5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 80),
                    ],
                  ),
                  const SizedBox(height: 60),
                  Transform.scale(
                    scale: 1.175,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        // InputCard(
                        //   title: "Agendador",
                        //   width: 220.0,
                        //   child: CustomRadioButton(radioModels: _schedulers),
                        // ),
                        InputTextCard(
                          title: "Tamanho",
                          width: 220,
                          child: RadioTextButton(radioModels: _imageDimensions),
                        ),
                        const SizedBox(width: 35.0),
                        InputTextCard(
                          title: "Quantidade",
                          width: 220,
                          child: RadioTextButton(radioModels: _numOutputs),
                        ),
                        const SizedBox(width: 35.0),
                        InputTextCard(
                          title: "Semente",
                          width: 220,
                          child: SizedBox(
                            height: 35.0,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (String text) {
                                _seed = text;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                                hintText: "0",
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  InputImageCard(
                    title: "Estilos",
                    child: RadioImageButton(
                      radioModels: _styles,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      InputImageCard(
                        title: "Saturação",
                        width: 530,
                        child: RadioImageButton(
                          radioModels: _saturations,
                        ),
                      ),
                      const SizedBox(width: 30),
                      InputImageCard(
                        title: "Iluminação",
                        width: 530,
                        child: RadioImageButton(
                          radioModels: _values,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  InputImageCard(
                    title: "Cores",
                    child: RadioImageButton(
                      radioModels: _colors,
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            // ====================
            // Gerações
            // ====================
            Container(
              width: 180,
              padding: const EdgeInsets.all(20.0),
              color: const Color.fromARGB(255, 13, 13, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Gerações",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Lexend",
                          fontSize: 16.0,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.white),
                        ),
                        child: IconButton(
                          onPressed: () {
                            log("Download!");
                          },
                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 18.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _generations.length,
                      separatorBuilder: (BuildContext context, int i) {
                        return const SizedBox(height: 16.0);
                      },
                      itemBuilder: (BuildContext context, int i) {
                        var generation = _generations[i];
                        List<Widget> children = [];

                        for (var image in generation.images) {
                          children.add(Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.network(
                                image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ));
                        }
                        return Container(
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Column(children: children),
                        );
                      },
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

import 'dart:developer';

import 'package:artemis/api/api_service.dart';
import 'package:artemis/enums/image_dimension.dart';
import 'package:artemis/enums/image_saturation.dart';
import 'package:artemis/enums/image_style.dart';
import 'package:artemis/enums/image_value.dart';
import 'package:artemis/enums/scheduler.dart';
import 'package:artemis/models/radio_model.dart';
import 'package:artemis/models/text2image/artemis_input_api.dart';
import 'package:artemis/models/text2image/artemis_output_api.dart';
import 'package:artemis/widgets/app_bar/artemis_app_bar.dart';
import 'package:artemis/widgets/custom/artemis_network_image.dart';
import 'package:artemis/widgets/diamond_separator.dart';
import 'package:artemis/widgets/image_visualizer.dart';
import 'package:artemis/widgets/input_image_card.dart';
import 'package:artemis/widgets/input_text_card.dart';
import 'package:artemis/widgets/radio_image_button.dart';
import 'package:artemis/widgets/radio_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/maps.dart';

class Text2ImagePage extends StatefulWidget {
  const Text2ImagePage({super.key});

  @override
  State<Text2ImagePage> createState() => _Text2ImagePageState();
}

class _Text2ImagePageState extends State<Text2ImagePage> {
  String _prompt = "";
  String _negativePrompt = "";
  String? _seed;

  final List<ArtemisOutputAPI> _outputs = [
    ArtemisOutputAPI(
      input: ArtemisInputAPI(
        prompt: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
      ),
    ),
    ArtemisOutputAPI(
      input: ArtemisInputAPI(
        prompt: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout."
            "The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using",
        guidanceScale: 1,
        imageDimensions: ImageDimensions.dim768,
        scheduler: Scheduler.klms,
        numOutputs: 2,
        seed: 100,
      ),
    ),
    ArtemisOutputAPI(
      input: ArtemisInputAPI(
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
    ArtemisOutputAPI(
      input: ArtemisInputAPI(
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

  // NOTE: These functions will be on the Python backend
  void _postRequest(ArtemisInputAPI input) async {
    _prompt = "A bedroom with nobody but a lot of furniture";

    if (_prompt.isNotEmpty) {
      Map<String, dynamic>? res = await ArtemisApiService.postPrompt(input);
      // _id = res?["id"];

      // var results = res?["results"];
      // id = results?[0]["id"];

      // print(res.toString());
      // log(_id ?? "Não foi possível gerar a imagem");
    }
    // Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  int temporary = 0;

  void _getRequest(List<String> idList) async {
    idList.add(temporary.toString());
    temporary++;

    if (idList.isNotEmpty) {
      log(idList.toString());
      Map<String, dynamic>? res = await ArtemisApiService.getStatus(idList);

      if (res != null) {
        log("Response Keys:");
        for (String key in res.keys) {
          log("\t- $key");
        }

        log(res["total"].toString());
      }

      // if (res != null) {
      //   log(res.toString());

      //   // if (res["status"] == "succeeded") {
      //   //   log(res["output"][0]);
      //   //   _imageUrl = res["output"][0];
      //   //   setState(() {});
      //   // }

      //   return;
      // }
    }
  }

  @override
  void initState() {
    super.initState();

    for (var element in ImageDimensions.values) {
      _imageDimensions.add(RadioModel(
        value: element,
        label: element.toReplicateAPI(),
      ));
    }

    for (var element in Scheduler.values) {
      _schedulers.add(RadioModel(
        value: element,
        label: element.toReplicateAPI(),
      ));
    }

    for (int i = 1; i < 5; i++) {
      _numOutputs.add(RadioModel(
        value: i,
        label: i.toString(),
      ));
    }

    for (final mapEntry in colorMap.entries) {
      _colors.add(ImageRadioModel(
        value: mapEntry.key,
        label: mapEntry.value,
        backgroundColor: mapEntry.key,
      ));
    }

    for (var style in ImageStyle.values) {
      _styles.add(ImageRadioModel(
        value: style,
        label: style.toDisplay(),
        imageUrl: imageMapping[style],
      ));
    }

    for (var saturation in ImageSaturation.values) {
      _saturations.add(ImageRadioModel(
        value: saturation,
        label: saturation.toDisplay(),
        imageUrl: imageMapping[saturation],
      ));
    }

    for (var value in ImageValue.values) {
      _values.add(ImageRadioModel(
        value: value,
        label: value.toDisplay(),
        imageUrl: imageMapping[value],
      ));
    }

    _imageDimensions[0].isSelected = true;
    _schedulers[0].isSelected = true;
    _numOutputs[0].isSelected = true;
    _colors[0].isSelected = true;
    _styles[0].isSelected = true;
    _saturations[0].isSelected = true;
    _values[0].isSelected = true;

    //================
    // Init Outputs
    //================
    _outputs[0].images = [
      imageMapping[0]!,
    ];

    _outputs[1].images = [
      imageMapping[1]!,
      imageMapping[2]!,
    ];

    _outputs[2].images = [
      imageMapping[3]!,
      imageMapping[4]!,
      imageMapping[5]!,
    ];

    _outputs[3].images = [
      imageMapping[2]!,
      imageMapping[1]!,
      imageMapping[4]!,
      imageMapping[0]!,
    ];
  }

  void generateImage() {
    _prompt = "A bedroom with nobody but a lot of furniture";

    if (_prompt.isEmpty) {
      return;
    }

    ArtemisInputAPI input = ArtemisInputAPI(prompt: _prompt);

    for (RadioModel element in _imageDimensions) {
      if (element.isSelected) {
        input.imageDimensions = element.value as ImageDimensions;
      }
    }

    for (RadioModel element in _numOutputs) {
      if (element.isSelected) {
        input.numOutputs = element.value as int;
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
    log(_negativePrompt);
    log(_prompt);

    _getRequest(["1", "2", "3"]);
    _postRequest(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ArtemisAppBar(),
      body: Row(
        children: [
          Expanded(
            child: Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                onPressed: generateImage,
                icon: const Icon(Icons.send),
                label: const Text("Gerar Imagem"),
                backgroundColor: const Color.fromARGB(255, 10, 150, 200),
              ),
              body: ListView(
                padding: const EdgeInsets.all(50),
                children: [
                  Container(
                    margin: const EdgeInsets.all(60),
                    alignment: Alignment.center,
                    child: const Text(
                      "Texto à Imagem",
                      textAlign: TextAlign.center,
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
                  const DiamondSeparator(
                    margin: EdgeInsets.symmetric(vertical: 60),
                    widthFactor: 0.8,
                  ),
                  Transform.scale(
                    scale: 1.175,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 35,
                      runSpacing: 35,
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
                        InputTextCard(
                          title: "Quantidade",
                          width: 220,
                          child: RadioTextButton(radioModels: _numOutputs),
                        ),
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
                    title: "Estilo",
                    child: RadioImageButton(
                      radioModels: _styles,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.spaceEvenly,
                    runSpacing: 20,
                    spacing: 30,
                    children: [
                      InputImageCard(
                        title: "Saturação",
                        width: 530,
                        child: RadioImageButton(
                          radioModels: _saturations,
                        ),
                      ),
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
                    title: "Cor Principal",
                    child: RadioImageButton(
                      radioModels: _colors,
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // ====================
          // Gerações
          // ====================
          SizedBox(
            width: 180,
            child: Container(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
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
                      itemCount: _outputs.length,
                      separatorBuilder: (BuildContext context, int i) {
                        return const SizedBox(height: 16.0);
                      },
                      itemBuilder: (BuildContext context, int i) {
                        var output = _outputs[i];
                        List<Widget> children = [];

                        for (int j = 0; j < output.images.length; j++) {
                          children.add(
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return ImageVisualizer(
                                        outputs: _outputs,
                                        setIndex: i,
                                        imageIndex: j,
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: ArtemisNetworkImage(
                                      output.images[j],
                                      progressColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
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
          ),
        ],
      ),
    );
  }
}

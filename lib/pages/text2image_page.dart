import 'dart:developer';

import 'package:artemis/api/api_service.dart';
import 'package:artemis/enums/image_dimension.dart';
import 'package:artemis/enums/image_saturation.dart';
import 'package:artemis/enums/image_style.dart';
import 'package:artemis/enums/image_value.dart';
import 'package:artemis/enums/scheduler.dart';
import 'package:artemis/models/text2image/artemis_input_api.dart';
import 'package:artemis/models/text2image/artemis_output_api.dart';
import 'package:artemis/models/user.dart';
import 'package:artemis/utils/radio_controller.dart';
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
  final User _user = User(BigInt.from(1), "carlosmito");
  String _prompt = "";
  String _negativePrompt = "";
  String? _seed;

  final List<ArtemisOutputAPI> _outputs = [];

  final RadioController _imageDimensions = RadioController(radioModels: <RadioModel<ImageDimensions>>[]);
  final RadioController _schedulers = RadioController(radioModels: <RadioModel<Scheduler>>[]);
  final RadioController _numOutputs = RadioController(radioModels: <RadioModel<int>>[]);
  final RadioController _colors = RadioController(radioModels: <RadioModel<int>>[]);
  final RadioController _styles = RadioController(radioModels: <RadioModel<ImageStyle>>[]);
  final RadioController _saturations = RadioController(radioModels: <RadioModel<ImageSaturation>>[]);
  final RadioController _values = RadioController(radioModels: <RadioModel<ImageValue>>[]);

  // NOTE: These functions will be on the Python backend
  // void _postPrompt(ArtemisInputAPI input) async {
  //   if (input.prompt.isNotEmpty) {
  //     Map<String, dynamic>? res = await ArtemisApiService.postPrompt(input);
  //     // _id = res?["id"];

  //     // var results = res?["results"];
  //     // id = results?[0]["id"];

  //     // print(res.toString());
  //     // log(_id ?? "Não foi possível gerar a imagem");
  //   }
  //   // Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  // }

  void _getStatus(List<String> idList) async {
    idList = ["pmnwbgwobjbvfbrin4whyfgqee"];

    if (idList.isNotEmpty) {
      log(idList.toString());
      Map<String, dynamic>? response = await ArtemisApiService.getStatus(idList);

      if (response != null) {
        log(response.toString());

        if (response["outputs"] != null) {
          // log(response["output"][0]);
          // _imageUrl = response["output"][0];
          // setState(() {});
        }
      }
    }
  }

  void _initRadioControllers() {
    for (var element in ImageDimensions.values) {
      _imageDimensions.radioModels.add(RadioModel<ImageDimensions>(
        value: element,
        label: element.toReplicateAPI(),
      ));
    }

    for (var element in Scheduler.values) {
      _schedulers.radioModels.add(RadioModel<Scheduler>(
        value: element,
        label: element.toReplicateAPI(),
      ));
    }

    for (int i = 1; i < 5; i++) {
      _numOutputs.radioModels.add(RadioModel<int>(
        value: i,
        label: i.toString(),
      ));
    }

    for (final mapEntry in colorMap.entries) {
      _colors.radioModels.add(RadioModel<int>(
        value: mapEntry.key,
        label: mapEntry.value,
        backgroundColor: Color(mapEntry.key),
      ));
    }

    for (var style in ImageStyle.values) {
      _styles.radioModels.add(RadioModel<ImageStyle>(
        value: style,
        label: style.toDisplay(),
        assetImage: imageMapping[style],
      ));
    }

    for (var saturation in ImageSaturation.values) {
      _saturations.radioModels.add(RadioModel<ImageSaturation>(
        value: saturation,
        label: saturation.toDisplay(),
        assetImage: imageMapping[saturation],
      ));
    }

    for (var value in ImageValue.values) {
      _values.radioModels.add(RadioModel<ImageValue>(
        value: value,
        label: value.toDisplay(),
        assetImage: imageMapping[value],
      ));
    }

    for (var controller in [_imageDimensions, _schedulers, _numOutputs, _colors, _styles, _saturations, _values]) {
      controller.selectFirst();
    }
  }

  void _createExampleData() {
    _outputs.addAll([
      ArtemisOutputAPI(
        input: ArtemisInputAPI(
          user: _user,
          prompt: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
        ),
      ),
      ArtemisOutputAPI(
        input: ArtemisInputAPI(
          user: _user,
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
          user: _user,
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
      ),
      ArtemisOutputAPI(
        input: ArtemisInputAPI(
          user: _user,
          prompt: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
          numOutputs: 4,
          colorValue: Colors.pink.value,
          value: ImageValue.low,
        ),
      )
    ]);

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

  void _fetchCreations() async {}

  @override
  void initState() {
    super.initState();

    _initRadioControllers();
    _createExampleData();
    _fetchCreations();
  }

  void _generateImage() async {
    // TODO: Create a mechanism to refresh depending when the image was downloaded (creation completed)

    // Prompts used to test
    // IDs: [1836712131, ?]
    // goddess close-up portrait skull with mohawk, ram skull, skeleton, thorax, x-ray, backbone, jellyfish phoenix head, nautilus, orchid, skull, betta fish, bioluminiscent creatures, intricate artwork by Tooth Wu and wlop and beeple. octane render, trending on artstation, greg rutkowski very coherent symmetrical artwork. cinematic, hyper realism, high detail, octane render, 8k
    // IDs: [156196113, 2954722577]
    // portrait skull with mohawk

    // space girl| standing alone on hill| centered| detailed gorgeous face| anime style| key visual| intricate detail| highly detailed| breathtaking| vibrant| panoramic| cinematic| Carne Griffiths| Conrad Roset| ghibli
    // 12th centuryhalf naked female samurai in the style of greg rutkowski and Guweiz and Yoji Shinkawa, intricate black and red samurai armor, cinematic lighting, dark rainy city, depth of field, lumen reflections, photography, stunning environment, hyperrealism, insanely detailed, midjourneyart style
    // a portrait of an old coal miner in 19th century, beautiful painting with highly detailed face by greg rutkowski and magali villanueve

    _prompt = "portrait skull with mohawk";

    if (_prompt.isEmpty) {
      return;
    }

    ArtemisInputAPI input = ArtemisInputAPI(
      user: _user,
      prompt: _prompt,
      negativePrompt: _negativePrompt,
    );

    if (_seed != null) input.seed = int.parse(_seed!);

    input.colorValue = _colors.selectedModel!.value;
    // input.imageDimensions = _imageDimensions.selectedModel!.value;
    // input.scheduler = _schedulers.selectedModel!.value;
    input.numOutputs = _numOutputs.selectedModel!.value;
    input.style = _styles.selectedModel!.value;
    input.saturation = _saturations.selectedModel!.value;
    input.value = _values.selectedModel!.value;

    // input.numOutputs = 4;

    debugPrint(input.toString());

    Map<String, dynamic>? response = await ArtemisApiService.postPrompt(input);
    log(response.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const ArtemisAppBar().preferredSize,
        child: const Hero(
          tag: ArtemisAppBar,
          child: ArtemisAppBar(),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                onPressed: _generateImage,
                icon: const Icon(Icons.send),
                label: const Text("Gerar Imagem"),
                backgroundColor: const Color.fromARGB(255, 10, 150, 200),
              ),
              body: ListView(
                padding: const EdgeInsets.all(50),
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _getStatus([]),
                        child: const Text("GET"),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: _generateImage,
                        child: const Text("POST"),
                      ),
                    ],
                  ),
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
                        //   child: CustomRadioButton(radioController: _schedulers),
                        // ),
                        InputTextCard(
                          title: "Tamanho",
                          width: 220,
                          child: RadioTextButton(radioController: _imageDimensions),
                        ),
                        InputTextCard(
                          title: "Quantidade",
                          width: 220,
                          child: RadioTextButton(radioController: _numOutputs),
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
                      radioController: _styles,
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
                          radioController: _saturations,
                        ),
                      ),
                      InputImageCard(
                        title: "Iluminação",
                        width: 530,
                        child: RadioImageButton(
                          radioController: _values,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  InputImageCard(
                    title: "Cor Principal",
                    child: RadioImageButton(
                      radioController: _colors,
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

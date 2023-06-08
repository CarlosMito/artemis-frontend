import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:js_interop';

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
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  int? _currentInputId;
  Timer? updateStatusTimer;

  List<List<ArtemisOutputAPI>>? _outputs = [];

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

  void _updateStatus([int? inputId]) async {
    var targetId = inputId ?? _currentInputId;

    if (targetId != null) {
      log(targetId.toString());
      Map<String, dynamic>? response = await ArtemisApiService.updateStatus(targetId.toString());

      if (response != null) {
        log(response.toString());

        List<int>? percentages = response["percentages"];

        if (percentages != null) {
          if (percentages.reduce(math.min) >= 100) {}
          _currentInputId = null;
          updateStatusTimer?.cancel();
          _getCreations();
        }
      }
    } else {
      updateStatusTimer?.cancel();
    }
  }

  void _loginArtemis() async {
    String? username = dotenv.env["USERNAME_TEST"];
    String? password = dotenv.env["PASSWORD_TEST"];

    if (username != null && password != null) {
      ArtemisApiService.loginArtemis(username, password);
    }
  }

  void _logoutArtemis() async {
    ArtemisApiService.logoutArtemis();
  }

  void _getCreations() async {
    var auxiliar = await ArtemisApiService.getCreations(_user);

    if (auxiliar != null) {
      _outputs = auxiliar.reversed.toList();
      setState(() {});
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
    List<ArtemisInputAPI> inputs = [
      ArtemisInputAPI(
        userId: _user.id,
        prompt: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
      ),
      ArtemisInputAPI(
        userId: _user.id,
        prompt: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout."
            "The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using",
        guidanceScale: 1,
        imageDimensions: ImageDimensions.dim768,
        scheduler: Scheduler.klms,
        numOutputs: 2,
        seed: 100,
      ),
      ArtemisInputAPI(
        userId: _user.id,
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
      ArtemisInputAPI(
        userId: _user.id,
        prompt: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
        numOutputs: 4,
        colorValue: Colors.pink.value,
        value: ImageValue.low,
      )
    ];

    _outputs?.addAll([
      [
        ArtemisOutputAPI(
          input: inputs[0],
          image: imageMapping[0]!,
        )
      ],
      [
        ArtemisOutputAPI(
          input: inputs[1],
          image: imageMapping[1]!,
        ),
        ArtemisOutputAPI(
          input: inputs[1],
          image: imageMapping[2]!,
        )
      ],
      [
        ArtemisOutputAPI(
          input: inputs[2],
          image: imageMapping[3]!,
        ),
        ArtemisOutputAPI(
          input: inputs[2],
          image: imageMapping[4]!,
        ),
        ArtemisOutputAPI(
          input: inputs[2],
          image: imageMapping[5]!,
        )
      ],
      [
        ArtemisOutputAPI(
          input: inputs[3],
          image: imageMapping[2]!,
        ),
        ArtemisOutputAPI(
          input: inputs[3],
          image: imageMapping[1]!,
        ),
        ArtemisOutputAPI(
          input: inputs[3],
          image: imageMapping[4]!,
        ),
        ArtemisOutputAPI(
          input: inputs[3],
          image: imageMapping[0]!,
        )
      ],
    ]);
  }

  showAlertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            // contentPadding: EdgeInsets.only(bottom: 20.0),
            title: Text(
              "Prompt Vazio",
              style: TextStyle(fontSize: 24.0),
            ),
            // content: Container(
            //   padding: const EdgeInsets.all(20),
            //   child: const Text("O campo prompt é obrigatório"),
            // ),
          );
        });
  }

  @override
  void initState() {
    super.initState();

    _initRadioControllers();
    _createExampleData();
    // _getCreations();
  }

  @override
  void dispose() {
    updateStatusTimer?.cancel();
    super.dispose();
  }

  void _generateImage() async {
    // TODO: Create a mechanism to refresh depending when the image was downloaded (creation completed)

    // Prompts used to test
    // IDs: [1836712131, ?]
    // goddess close-up portrait skull with mohawk, ram skull, skeleton, thorax, x-ray, backbone, jellyfish phoenix head, nautilus, orchid, skull, betta fish, bioluminiscent creatures, intricate artwork by Tooth Wu and wlop and beeple. octane render, trending on artstation, greg rutkowski very coherent symmetrical artwork. cinematic, hyper realism, high detail, octane render, 8k
    // IDs: [156196113, 2954722577]
    // portrait skull with mohawk

    // [Not working]
    // space girl| standing alone on hill| centered| detailed gorgeous face| anime style| key visual| intricate detail| highly detailed| breathtaking| vibrant| panoramic| cinematic| Carne Griffiths| Conrad Roset| ghibli

    // 12th century female samurai in the style of greg rutkowski and Guweiz and Yoji Shinkawa, intricate black and red samurai armor, cinematic lighting, dark rainy city, depth of field, lumen reflections, photography, stunning environment, hyperrealism, insanely detailed, midjourneyart style

    // a portrait of an old coal miner in 19th century, beautiful painting with highly detailed face by greg rutkowski and magali villanueve
    // IDs: [2469936864]

    // "a portrait of an old coal miner in 19th century"
    // IDs: [3985702484]

    _prompt =
        "airy, pin-up, sci-fi, steam punk, very deitaled, realistic, figurative painter, fineart, Oil painting on canvas, beautiful painting by Daniel F Gerhartz --ar 9:16 --beta --upbeta";

    ArtemisInputAPI input = ArtemisInputAPI(
      userId: _user.id,
      prompt: _prompt,
      negativePrompt: _negativePrompt,
    );

    if (_seed != null) input.seed = int.parse(_seed!);

    input.colorValue = _colors.selectedModel!.value;
    input.imageDimensions = _imageDimensions.selectedModel!.value;
    input.scheduler = _schedulers.selectedModel!.value;
    input.numOutputs = _numOutputs.selectedModel!.value;
    input.style = _styles.selectedModel!.value;
    input.saturation = _saturations.selectedModel!.value;
    input.value = _values.selectedModel!.value;

    // ==========================
    // Template image generation
    // ==========================
    // input.numOutputs = 4;

    if (_currentInputId == null) {
      _currentInputId = await ArtemisApiService.postPrompt(input);

      if (_currentInputId != null) {
        updateStatusTimer = Timer.periodic(const Duration(seconds: 2), (Timer t) => _updateStatus());
        log(_currentInputId.toString());
      }
    } else {
      log("Another creation in process!");
    }
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
                onPressed: () {
                  if (_prompt.isEmpty) {
                    // showAlertDialog();
                    return;
                  }
                  // setState(() {
                  //   _validatePrompt = _prompt.isNotEmpty;
                  // });
                  _generateImage();
                },
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
                        onPressed: () => _updateStatus(29),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                        child: const Text("UPDATE STATUS"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: _generateImage,
                        child: const Text("REQUEST CREATION"),
                      ),
                      ElevatedButton(
                        onPressed: () => _getCreations(),
                        child: const Text("GET OUTPUTS"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                        ),
                        onPressed: _loginArtemis,
                        child: const Text("LOGIN"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: _logoutArtemis,
                        child: const Text("LOGOUT"),
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
                      itemCount: _outputs?.length ?? 0,
                      separatorBuilder: (BuildContext context, int i) {
                        return const SizedBox(height: 16.0);
                      },
                      itemBuilder: (BuildContext context, int i) {
                        var outputset = _outputs![i];
                        List<Widget> children = [];

                        if (outputset.isEmpty) return const SizedBox.shrink();

                        for (int j = 0; j < outputset.length; j++) {
                          children.add(
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return ImageVisualizer(outputs: _outputs!, setIndex: i, imageIndex: j);
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
                                      outputset[j].image,
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

import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:artemis/api/api_service.dart';
import 'package:artemis/enums/image_dimension.dart';
import 'package:artemis/enums/image_saturation.dart';
import 'package:artemis/enums/image_style.dart';
import 'package:artemis/enums/image_value.dart';
import 'package:artemis/enums/model_version.dart';
import 'package:artemis/enums/scheduler.dart';
import 'package:artemis/models/text2image/artemis_input_api.dart';
import 'package:artemis/models/text2image/artemis_output_api.dart';
import 'package:artemis/models/user.dart';
import 'package:artemis/utils/custom_range_text_input_formatter.dart';
import 'package:artemis/utils/image_downloader.dart';
import 'package:artemis/utils/radio_controller.dart';
import 'package:artemis/widgets/app_bar/artemis_app_bar.dart';
import 'package:artemis/widgets/custom/artemis_network_image.dart';
import 'package:artemis/widgets/diamond_separator.dart';
import 'package:artemis/widgets/image_visualizer.dart';
import 'package:artemis/widgets/input_image_card.dart';
import 'package:artemis/widgets/input_text_card.dart';
import 'package:artemis/widgets/radio_dropdown_button.dart';
import 'package:artemis/widgets/radio_image_button.dart';
import 'package:artemis/widgets/radio_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:archive/archive_io.dart';

import '../utils/maps.dart';

class Text2ImagePage extends StatefulWidget {
  final ArtemisInputAPI? startingInput;
  const Text2ImagePage({super.key, this.startingInput});

  @override
  State<Text2ImagePage> createState() => _Text2ImagePageState();
}

class _Text2ImagePageState extends State<Text2ImagePage> {
  final promptController = TextEditingController();
  final negativePromptController = TextEditingController();
  final seedController = TextEditingController();
  final numInferenceStepsController = TextEditingController();
  final guidanceScaleController = TextEditingController();

  final User _user = User(id: BigInt.from(1), username: "carlosmito", email: "carlosmito@email.com");
  Timer? updateStatusTimer;

  List<dynamic> _outputs = [null];

  final RadioController _imageDimensions = RadioController(radioModels: <RadioModel<ImageDimensions>>[]);
  final RadioController _schedulers = RadioController(radioModels: <RadioModel<Scheduler>>[]);
  final RadioController _numOutputs = RadioController(radioModels: <RadioModel<int>>[]);
  final RadioController _colors = RadioController(radioModels: <RadioModel<int>>[]);
  final RadioController _styles = RadioController(radioModels: <RadioModel<ImageStyle>>[]);
  final RadioController _saturations = RadioController(radioModels: <RadioModel<ImageSaturation>>[]);
  final RadioController _values = RadioController(radioModels: <RadioModel<ImageValue>>[]);
  final RadioController _versions = RadioController(radioModels: <RadioModel<StableDiffusionVersion>>[]);

  bool isProcessingDownload = false;

  Future<void> _updateStatus([int? inputId]) async {
    var targetId = inputId ?? _outputs[0];

    if (targetId != null) {
      Map<String, dynamic>? response = await ArtemisApiService.updateStatus(targetId.toString());

      if (response != null) {
        if (response.containsKey("error")) {
          _outputs[0] = null;
          updateStatusTimer?.cancel();
          setState(() {});
          return;
        }

        List<int>? percentages = response["percentages"].toList().cast<int>();

        if (percentages != null && percentages.isNotEmpty) {
          if (percentages.reduce(math.min) >= 100) {
            _outputs[0] = null;
            updateStatusTimer?.cancel();
            _postProcessing(targetId!);
            _getCreations();
          }
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

  void _postProcessing(int inputId) async {
    await ArtemisApiService.postProcessing(inputId.toString());
  }

  void _getCreations() async {
    var auxiliar = await ArtemisApiService.getCreations();

    if (auxiliar != null) {
      _outputs = [null, ...auxiliar.reversed.toList()];
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

    for (var element in StableDiffusionVersion.values) {
      _versions.radioModels.add(RadioModel<StableDiffusionVersion>(
        value: element,
        label: element.toDisplay(),
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

    for (var controller in [_imageDimensions, _schedulers, _numOutputs, _colors, _styles, _saturations, _values, _versions]) {
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

    _outputs.addAll([
      // 1,
      [
        ArtemisOutputAPI(
          id: BigInt.zero,
          input: inputs[0],
          image: imageMapping[0]!,
        )
      ],
      [
        ArtemisOutputAPI(
          id: BigInt.zero,
          input: inputs[1],
          image: imageMapping[1]!,
        ),
        ArtemisOutputAPI(
          id: BigInt.zero,
          input: inputs[1],
          image: imageMapping[2]!,
        )
      ],
      [
        ArtemisOutputAPI(
          id: BigInt.zero,
          input: inputs[2],
          image: imageMapping[3]!,
        ),
        ArtemisOutputAPI(
          id: BigInt.zero,
          input: inputs[2],
          image: imageMapping[4]!,
        ),
        ArtemisOutputAPI(
          id: BigInt.zero,
          input: inputs[2],
          image: imageMapping[5]!,
        )
      ],
      [
        ArtemisOutputAPI(
          id: BigInt.zero,
          input: inputs[3],
          image: imageMapping[2]!,
        ),
        ArtemisOutputAPI(
          id: BigInt.zero,
          input: inputs[3],
          image: imageMapping[1]!,
        ),
        ArtemisOutputAPI(
          id: BigInt.zero,
          input: inputs[3],
          image: imageMapping[4]!,
        ),
        ArtemisOutputAPI(
          id: BigInt.zero,
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

    if (widget.startingInput != null) {
      updateInput(widget.startingInput!);
    }
  }

  @override
  void dispose() {
    updateStatusTimer?.cancel();
    promptController.dispose();
    negativePromptController.dispose();
    seedController.dispose();
    numInferenceStepsController.dispose();
    guidanceScaleController.dispose();
    super.dispose();
  }

  void _generateImage() async {
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

    // _prompt =
    //     "airy, pin-up, sci-fi, steam punk, very deitaled, realistic, figurative painter, fineart, Oil painting on canvas, beautiful painting by Daniel F Gerhartz --ar 9:16 --beta --upbeta";

    // TODO: The user ID into the post creation method is useless since I can get the ID from the request itself
    ArtemisInputAPI input = ArtemisInputAPI(
      userId: _user.id,
      prompt: promptController.text,
      negativePrompt: negativePromptController.text,
    );

    if (seedController.text.isNotEmpty) input.seed = int.parse(seedController.text);
    if (numInferenceStepsController.text.isNotEmpty) input.numInferenceSteps = int.parse(numInferenceStepsController.text);
    if (guidanceScaleController.text.isNotEmpty) {
      String text = guidanceScaleController.text;

      if (text[text.length - 1] == '.') {
        text = "${text}0";
      }

      input.guidanceScale = double.parse(text);
    }

    input.colorValue = _colors.selectedModel!.value;
    input.imageDimensions = _imageDimensions.selectedModel!.value;
    input.scheduler = _schedulers.selectedModel!.value;
    input.numOutputs = _numOutputs.selectedModel!.value;
    input.style = _styles.selectedModel!.value;
    input.saturation = _saturations.selectedModel!.value;
    input.value = _values.selectedModel!.value;
    input.version = _versions.selectedModel!.value;

    // ==========================
    // Template image generation
    // ==========================
    // input.numOutputs = 2;

    if (_outputs[0] == null) {
      _outputs[0] = await ArtemisApiService.postPrompt(input);

      if (_outputs[0] != null) {
        updateStatusTimer = Timer.periodic(const Duration(seconds: 2), (Timer t) async {
          await _updateStatus();
        });
        setState(() {});
      }
    } else {
      log("Another creation in process!");
    }
  }

  void _downloadImagesAsZip(List<String> urls) async {
    final archive = Archive();

    setState(() {
      isProcessingDownload = true;
    });

    try {
      // Add files to the archive
      for (String url in urls) {
        String filename = url.split("/").last;
        final imageBytes = await readImageAsBytes(url);
        archive.addFile(ArchiveFile(filename, imageBytes.length, imageBytes));
      }
    } catch (e) {
      log(e.toString());
    }

    try {
      // Create the zip file
      final zipData = ZipEncoder().encode(archive);
      downloadFileFromBytes("myGenerations.zip", zipData!);
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        isProcessingDownload = false;
      });
    }
  }

  void updateInput(ArtemisInputAPI input) {
    setState(() {
      promptController.text = input.prompt;
      negativePromptController.text = input.negativePrompt;
      seedController.text = input.seed.toString();
      guidanceScaleController.text = input.guidanceScale.toString();
      numInferenceStepsController.text = input.numInferenceSteps.toString();
      _imageDimensions.selectTarget(input.imageDimensions);
      _numOutputs.selectTarget(input.numOutputs);
      _schedulers.selectTarget(input.scheduler);
      _styles.selectTarget(input.style);
      _saturations.selectTarget(input.saturation);
      _values.selectTarget(input.value);
      _colors.selectTarget(input.colorValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const ArtemisAppBar().preferredSize,
        child: ArtemisAppBar(onLogin: _getCreations, onLogout: _getCreations),
      ),
      body: Row(
        children: [
          Expanded(
            child: Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  if (promptController.text.isEmpty) {
                    // showAlertDialog();
                    return;
                  }

                  _generateImage();
                },
                icon: const Icon(Icons.send),
                label: const Text("Gerar Imagem"),
                backgroundColor: const Color.fromARGB(255, 10, 150, 200),
              ),
              body: ListView(
                padding: const EdgeInsets.all(50),
                children: [
                  Wrap(
                    children: [
                      ElevatedButton(
                        onPressed: () => _postProcessing(42),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        child: const Text("POST PROCESSING"),
                      ),
                      ElevatedButton(
                        onPressed: () => _updateStatus(39),
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
                        child: const Text("GENERATE IMAGE"),
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
                    controller: promptController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Descreva o que você quer gerar",
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  TextField(
                    controller: negativePromptController,
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
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 35,
                    runSpacing: 35,
                    children: [
                      InputTextCard(
                        title: "Tamanho",
                        width: 300,
                        child: RadioTextButton(radioController: _imageDimensions),
                      ),
                      InputTextCard(
                        title: "Quantidade",
                        width: 300,
                        child: RadioTextButton(radioController: _numOutputs),
                      ),
                      InputTextCard(
                        title: "Semente",
                        width: 300,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: seedController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Aleatório",
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 35,
                    runSpacing: 35,
                    children: [
                      InputTextCard(
                        title: "Agendador",
                        width: 360,
                        child: RadioDropdownButton(controller: _schedulers),
                      ),
                      InputTextCard(
                        title: "Inferências",
                        width: 300,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CustomRangeTextInputFormatter(minValue: 1, maxValue: 500),
                          ],
                          controller: numInferenceStepsController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "50",
                            isDense: true,
                          ),
                        ),
                      ),
                      InputTextCard(
                        title: "Escala de Orientação",
                        width: 360,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r"([0-9]|\.)")),
                            CustomRangeTextInputFormatter(minValue: 1, maxValue: 20),
                          ],
                          controller: guidanceScaleController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "7.5",
                            isDense: true,
                          ),
                        ),
                      ),
                      // InputTextCard(
                      //   title: "Agendador",
                      //   width: 400,
                      //   child: RadioDropdownButton(controller: _versions),
                      // ),
                    ],
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
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(
                          child: isProcessingDownload
                              ? const Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: 18.0,
                                )
                              : IconButton(
                                  onPressed: () {
                                    log("Download all!");

                                    List<String> imagesUrls = [];

                                    for (final outputset in _outputs) {
                                      if (outputset == null) continue;

                                      for (final output in outputset as List<ArtemisOutputAPI>) {
                                        imagesUrls.add(output.image);
                                      }
                                    }

                                    log(imagesUrls.toString());

                                    _downloadImagesAsZip(imagesUrls);
                                  },
                                  icon: const Icon(
                                    Icons.download,
                                    color: Colors.white,
                                    size: 18.0,
                                  ),
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
                        if (_outputs[i] == null) return const SizedBox.shrink();

                        if (_outputs[i].runtimeType == int) {
                          return AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Colors.white),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }

                        // This decrement is important because the first element of [_outputs]
                        // is either null (when not generating an image) or an int (when generating)
                        int decrement = 1;

                        var onlyOutputs = _outputs.whereType<List<ArtemisOutputAPI>>().toList();
                        List<ArtemisOutputAPI> outputset = onlyOutputs[i - decrement];
                        List<Widget> children = [];

                        // TODO: When is empty, return an error image placeholder.
                        // The best would be to display an error when an specific image is unavailable instead of
                        // checking only the whole set, but... it'd be a lot of work
                        if (outputset.isEmpty) return const SizedBox.shrink();

                        // NOTE: This is not enough due to the counter when moving between images
                        // if (outputset.isEmpty) {
                        //   return Image.asset(
                        //     imageMapping[ArtemisPlaceholder.imageError]!,
                        //     fit: BoxFit.cover,
                        //   );
                        // }

                        for (int j = 0; j < outputset.length; j++) {
                          children.add(
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  ArtemisInputAPI? recreationInput = await showDialog(
                                    context: context,
                                    builder: (BuildContext currentContext) {
                                      return ImageVisualizer(
                                        outputs: onlyOutputs,
                                        setIndex: i - decrement,
                                        imageIndex: j,
                                      );
                                    },
                                  );

                                  if (recreationInput != null) {
                                    updateInput(recreationInput);
                                  }
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

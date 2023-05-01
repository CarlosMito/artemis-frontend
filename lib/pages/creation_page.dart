import 'dart:developer';

import 'package:artemis/enums/image_dimension.dart';
import 'package:artemis/enums/image_saturation.dart';
import 'package:artemis/enums/image_style.dart';
import 'package:artemis/enums/image_value.dart';
import 'package:artemis/models/input_api.dart';
import 'package:artemis/models/output_api.dart';
import 'package:artemis/enums/scheduler.dart';
import 'package:artemis/widgets/radio_image_button.dart';
import 'package:artemis/widgets/radio_text_button.dart';
import 'package:artemis/widgets/display_text_option.dart';
import 'package:artemis/widgets/input_text_card.dart';
import 'package:artemis/widgets/input_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../api_service.dart';

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
        imageDimensions: ImageDimension.dim768,
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
        imageDimensions: ImageDimension.dim768,
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
      ),
    ),
  ];

  final Map<Object, String> _imagePlaceholders = {
    0: "https://cdna.artstation.com/p/assets/images/images/055/955/238/20221110132828/smaller_square/rossdraws-makima-web-final.jpg?1668108508",
    1: "https://imagecache.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/5db7bc40-3147-42ca-797c-a8fe1100ac00/width=450/376255.jpeg",
    2: "https://64.media.tumblr.com/3098f52d522c10d35e50db9a29793585/c73f7e638a9a5a32-69/s1280x1920/7ab6808c581019fb81ec657d4c654791881a3c73.jpg",
    3: "https://pbs.twimg.com/media/EnSgAbxUYAARbee.jpg",
    4: "https://imagecache.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/0615e367-6e5f-4db9-78da-bb9bd68a0700/width=450/376252.jpeg",
    5: "https://cdna.artstation.com/p/assets/covers/images/044/328/314/smaller_square/rossdraws-rossdraws-tombra3.jpg?1639680124",
    ImageStyle.anime: "https://animemotivation.com/wp-content/uploads/2022/05/klee-genshin-impact-anime-fanart.png",
    ImageStyle.oilPainting: "https://as1.ftcdn.net/v2/jpg/03/28/53/82/1000_F_328538275_TWuK5PAmHktvg0P0MBdS5tpzQ4EScX9w.jpg",
    ImageStyle.digitalArt: "https://i.pinimg.com/originals/61/c3/b1/61c3b11e7770bd68ac268d95dc6ee790.jpg",
    ImageStyle.model3d: "https://cdn.daz3d.com/file/dazcdn/media/home_page/new/process/skin.jpg",
    ImageStyle.photography: "https://i1.adis.ws/i/canon/pro-fine-art-photography-tips-1_a956e5554f9143789db8e529c097e410",
    ImageSaturation.high: "https://image.lexica.art/md2/163ed32a-18fa-475d-a46d-2920da6d11ef",
    ImageSaturation.low: "https://drawpaintacademy.com/wp-content/uploads/2018/06/Dan-Scott-Secrets-on-the-Lake-Overcast-Day-2016-1200W-Web.jpg",
    ImageValue.high: "https://wallpaperaccess.com/full/2741468.jpg",
    ImageValue.low: "https://img.artpal.com/23433/1-15-3-28-5-14-35m.jpg",
  };

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

    for (var element in ImageDimension.values) {
      _imageDimensions.add(RadioModel(false, element, element.toReplicateAPI()));
    }

    for (var element in Scheduler.values) {
      _schedulers.add(RadioModel(false, element, element.toReplicateAPI()));
    }

    for (int i = 1; i < 5; i++) {
      _numOutputs.add(RadioModel(false, i, i.toString()));
    }

    var auxiliar = {
      "Preto": Colors.black,
      "Branco": Colors.white,
      "Vermelho": Colors.red,
      "Âmbar": Colors.amber,
      "Verde": Colors.green,
      "Azul": Colors.blueAccent,
      "Roxo": Colors.purple,
      "Indigo": Colors.indigo,
      "Cerceta": Colors.teal,
      "Laranja": Colors.orange,
      "Rosa": Colors.pink,
      "Ciano": Colors.cyan,
    };

    _styles.add(ImageRadioModel(true, label: "Aleatório", color: Colors.transparent));
    _colors.add(ImageRadioModel(true, label: "Aleatório", color: Colors.transparent));
    _saturations.add(ImageRadioModel(true, label: "Aleatório", color: Colors.transparent));
    _values.add(ImageRadioModel(true, label: "Aleatório", color: Colors.transparent));

    for (final mapEntry in auxiliar.entries) {
      _colors.add(ImageRadioModel(
        false,
        label: mapEntry.key,
        color: mapEntry.value,
      ));
    }

    for (var style in ImageStyle.values) {
      _styles.add(ImageRadioModel(
        false,
        label: style.toDisplay(),
        imageUrl: _imagePlaceholders[style],
      ));
    }

    for (var saturation in ImageSaturation.values) {
      _saturations.add(ImageRadioModel(
        false,
        label: saturation.toDisplay(),
        imageUrl: _imagePlaceholders[saturation],
      ));
    }

    for (var value in ImageValue.values) {
      _values.add(ImageRadioModel(
        false,
        label: value.toDisplay(),
        imageUrl: _imagePlaceholders[value],
      ));
    }

    _imageDimensions[0].isSelected = true;
    _schedulers[0].isSelected = true;
    _numOutputs[0].isSelected = true;

    //================
    // Init Outputs
    //================
    _generations[0].outputs = [
      _imagePlaceholders[0]!,
    ];

    _generations[1].outputs = [
      _imagePlaceholders[1]!,
      _imagePlaceholders[2]!,
    ];

    _generations[2].outputs = [
      _imagePlaceholders[3]!,
      _imagePlaceholders[4]!,
      _imagePlaceholders[5]!,
    ];

    _generations[3].outputs = [
      _imagePlaceholders[2]!,
      _imagePlaceholders[1]!,
      _imagePlaceholders[4]!,
      _imagePlaceholders[0]!,
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

          OutputAPI generation = _generations[2];

          showDialog(
            context: context,
            builder: (BuildContext ctx) {
              // context.size;
              return AlertDialog(
                content: AspectRatio(
                  aspectRatio: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(generation.outputs[0], fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text("Prompt"),
                            Flexible(child: Text(generation.input.prompt)),
                            Flexible(child: Text(generation.input.negativePrompt ?? "")),
                            Row(
                              children: [
                                DisplayTextOption(
                                  title: "Tamanho",
                                  value: generation.input.imageDimensions.toReplicateAPI(),
                                ),
                                DisplayTextOption(
                                  title: "Semente",
                                  value: generation.input.seed.toString(),
                                ),
                                DisplayTextOption(
                                  title: "Número de Inferências",
                                  value: generation.input.numInferenceSteps.toString(),
                                ),
                                DisplayTextOption(
                                  title: "Escala de Orientação",
                                  value: generation.input.guidanceScale.toString(),
                                ),
                                DisplayTextOption(
                                  title: "Agendador",
                                  value: generation.input.scheduler.toReplicateAPI(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
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
                    "Prompt",
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
                      // labelText: "Prompt",
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

                        for (var image in generation.outputs) {
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

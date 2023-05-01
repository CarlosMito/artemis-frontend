import 'dart:developer';

import 'package:artemis/models/image_dimension.dart';
import 'package:artemis/models/scheduler.dart';
import 'package:artemis/widgets/custom_radio_button.dart';
import 'package:artemis/widgets/input_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

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

  final List<List<String>> _imagesPlaceholder = [
    ["https://cdna.artstation.com/p/assets/images/images/055/955/238/20221110132828/smaller_square/rossdraws-makima-web-final.jpg?1668108508"],
    [
      "https://imagecache.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/5db7bc40-3147-42ca-797c-a8fe1100ac00/width=450/376255.jpeg",
      "https://64.media.tumblr.com/3098f52d522c10d35e50db9a29793585/c73f7e638a9a5a32-69/s1280x1920/7ab6808c581019fb81ec657d4c654791881a3c73.jpg",
      "https://pbs.twimg.com/media/EnSgAbxUYAARbee.jpg",
    ],
    [
      "https://imagecache.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/0615e367-6e5f-4db9-78da-bb9bd68a0700/width=450/376252.jpeg",
      "https://cdna.artstation.com/p/assets/covers/images/044/328/314/smaller_square/rossdraws-rossdraws-tombra3.jpg?1639680124"
    ]
  ];

  final List<RadioModel> _imageDimensions = [];
  final List<RadioModel> _schedulers = [];
  final List<RadioModel> _numOutputs = [];
  final List<RadioModel> _colors = [];

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

    var auxiliar = [
      Colors.black,
      Colors.red,
      Colors.amber,
      Colors.green,
      Colors.blueAccent,
      Colors.purple,
      Colors.yellow,
    ];

    for (var color in auxiliar) {
      _colors.add(RadioModel(false, color, color.toString()));
    }

    _imageDimensions[0].isSelected = true;
    _schedulers[0].isSelected = true;
    _numOutputs[0].isSelected = true;
    _colors[0].isSelected = true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            Expanded(
              flex: 88,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.network(
                    //   _imageUrl ?? "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
                    //   fit: BoxFit.contain,
                    //   width: 500,
                    // ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // _postRequest();
                        //   },
                        //   child: const Text("Enviar"),
                        // ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // _getRequest();
                        //   },
                        //   child: const Text("Verificar"),
                        // ),
                        ElevatedButton(
                          onPressed: () {
                            // for (RadioModel element in _schedulers) {
                            //   if (element.isSelected) {
                            //     log(element.value.toString());
                            //   }
                            // }
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

                            log(_seed ?? "");
                          },
                          child: const Text("Pegar valores"),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // InputCard(
                        //   title: "Agendador",
                        //   width: 220.0,
                        //   child: CustomRadioButton(radioModels: _schedulers),
                        // ),
                        InputCard(
                          title: "Tamanho",
                          width: 220.0,
                          child: CustomRadioButton(radioModels: _imageDimensions),
                        ),
                        const SizedBox(width: 35.0),
                        InputCard(
                          title: "Quantidade",
                          width: 220.0,
                          child: CustomRadioButton(radioModels: _numOutputs),
                        ),
                        const SizedBox(width: 35.0),
                        InputCard(
                          title: "Semente",
                          width: 220.0,
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
                    SizedBox(
                      height: 150.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            width: 500.0,
                            height: 100.0,
                            color: Colors.blue,
                          ),
                          Container(
                            width: 500.0,
                            height: 100.0,
                            color: Colors.red,
                          ),
                          Container(
                            width: 500.0,
                            height: 100.0,
                            color: Colors.orange,
                          ),
                          Container(
                            width: 500.0,
                            height: 100.0,
                            color: Colors.amber,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            // ====================
            // Gerações
            // ====================
            Expanded(
              flex: 12,
              child: Container(
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
                        itemCount: _imagesPlaceholder.length,
                        separatorBuilder: (BuildContext context, int i) {
                          return const SizedBox(height: 16.0);
                        },
                        itemBuilder: (BuildContext context, int i) {
                          var images = _imagesPlaceholder[i];
                          List<Widget> children = [];

                          for (var image in images) {
                            children.add(Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Image.network(
                                image,
                                fit: BoxFit.fill,
                                // width: 50.0,
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
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

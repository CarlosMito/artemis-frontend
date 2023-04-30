import 'dart:developer';

import 'package:artemis/models/image_dimension.dart';
import 'package:artemis/models/scheduler.dart';
import 'package:flutter/material.dart';

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

  List<RadioModel> _imageDimensions = [];

  // ImageDimension _imageDimensions = ImageDimension.dim512;

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

  List<Widget> createRadioItems(List<RadioModel> radioModels, [double? width, double? height]) {
    var radioItems = <Widget>[];

    for (int i = 0; i < radioModels.length; i++) {
      radioItems.add(Container(
        margin: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              for (var element in _imageDimensions) {
                element.isSelected = false;
              }
              _imageDimensions[i].isSelected = true;
            });
          },
          child: RadioItem(
            radioModel: radioModels[i],
            width: width,
            height: height,
          ),
        ),
      ));
    }

    return radioItems;
  }

  @override
  void initState() {
    super.initState();
    _imageDimensions.add(RadioModel(false, ImageDimension.dim512.name, ImageDimension.dim512));
    _imageDimensions.add(RadioModel(false, ImageDimension.dim768.name, ImageDimension.dim768));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Image.network(
          //   _imageUrl ?? "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
          //   fit: BoxFit.contain,
          //   width: 500,
          // ),
          Column(
            children: [
              const Text("Prompts"),
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
              TextField(
                onChanged: (String text) {
                  _negativePrompt = text;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Descreva o que você não quer ver na imagem",
                ),
              ),
            ],
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
                  for (Scheduler s in Scheduler.values) {
                    log(s.name);
                    log(s.toReplicateAPI());
                  }
                },
                child: const Text("Scheduler"),
              ),
              ElevatedButton(
                onPressed: () {
                  for (RadioModel element in _imageDimensions) {
                    if (element.isSelected) {
                      ImageDimension value = element.value as ImageDimension;
                      log(value.toString());
                    }
                  }
                },
                child: const Text("Image Dimension"),
              )
            ],
          ),
          Row(children: createRadioItems(_imageDimensions))
        ]),
      ),
    );
  }
}

class RadioModel {
  Object value;
  bool isSelected;
  final String text;

  RadioModel(this.isSelected, this.text, this.value);
}

class RadioItem extends StatelessWidget {
  // final String text;
  // final bool isSelected;
  final RadioModel radioModel;
  final double? height;
  final double? width;

  const RadioItem({super.key, required this.radioModel, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: radioModel.isSelected
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color.fromARGB(255, 13, 13, 16),
              border: Border.all(
                color: Colors.white,
                strokeAlign: -6.0,
              ),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.transparent,
              border: Border.all(
                color: const Color.fromARGB(255, 13, 13, 16),
              ),
            ),
      alignment: Alignment.center,
      child: Text(
        radioModel.text,
        style: TextStyle(
          color: radioModel.isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

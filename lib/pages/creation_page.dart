import 'dart:developer';

import 'package:artemis/models/image_dimension.dart';
import 'package:artemis/models/scheduler.dart';
import 'package:artemis/widgets/custom_radio_button.dart';
import 'package:artemis/widgets/input_card.dart';
import 'package:flutter/material.dart';
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

  final List<RadioModel> _imageDimensions = [];
  final List<RadioModel> _schedulers = [];
  final List<RadioModel> _numOutputs = [];

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

    _imageDimensions[0].isSelected = true;
    _schedulers[0].isSelected = true;
    _numOutputs[0].isSelected = true;
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
              InputCard(
                title: "Quantidade",
                width: 220.0,
                child: CustomRadioButton(radioModels: _numOutputs),
              ),
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
          )
        ]),
      ),
    );
  }
}

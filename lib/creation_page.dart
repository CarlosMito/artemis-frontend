import 'dart:developer';

import 'package:flutter/material.dart';

import 'api_service.dart';

class CreationPage extends StatefulWidget {
  const CreationPage({super.key});

  @override
  State<CreationPage> createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  String prompt = "";
  String? imageUrl;
  String? id;

  void _postRequest() async {
    if (prompt.isNotEmpty) {
      Map<String, dynamic>? res = await ApiService().postPrompt(prompt);
      id = res?["id"];

      // var results = res?["results"];
      // id = results?[0]["id"];

      print(res.toString());
      log(id ?? "Não foi possível gerar a imagem");
    }
    // Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void _getRequest() async {
    if (id != null) {
      Map<String, dynamic>? res = await ApiService().getStatus(id!);

      if (res != null) {
        log(res["status"]);

        if (res["status"] == "succeeded") {
          log(res["output"][0]);
          imageUrl = res["output"][0];
          setState(() {});
        }

        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.network(
            imageUrl ?? "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
            fit: BoxFit.contain,
            width: 500,
          ),
          TextField(
            onChanged: (String text) {
              prompt = text;
            },
            decoration: const InputDecoration(
              labelText: "Prompt",
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _postRequest();
                },
                child: const Text("Enviar"),
              ),
              ElevatedButton(
                onPressed: () {
                  _getRequest();
                },
                child: const Text("Verificar"),
              )
            ],
          )
        ]),
      ),
    );
  }
}

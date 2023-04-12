import 'package:flutter/material.dart';

import 'api_service.dart';

class CreationPage extends StatefulWidget {
  const CreationPage({super.key});

  @override
  State<CreationPage> createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  String prompt = "";

  void _callApi() async {
    print(await ApiService().postPrompt("a vision of paradise. unreal engine"));
    // Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            onChanged: (String text) {
              prompt = text;
            },
            decoration: const InputDecoration(
              labelText: "Prompt",
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _callApi();
            },
            child: const Text("Enviar"),
          )
        ]),
      ),
    );
  }
}

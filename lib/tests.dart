import 'dart:convert';

import 'package:artemis/models/text2image/artemis_input_api.dart';

void main() {
  var input = ArtemisInputAPI(prompt: "Prompt test");
  print(ArtemisInputAPI.fromJson(jsonDecode(jsonEncode(input))));
}

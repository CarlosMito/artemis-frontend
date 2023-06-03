// import 'dart:convert';

import 'package:artemis/models/text2image/artemis_input_api.dart';
import 'package:artemis/models/user.dart';

void main() {
  User user = User(BigInt.from(1), "test");
  ArtemisInputAPI(user: user, prompt: "Prompt test");
  // print(ArtemisInputAPI.fromJson(jsonDecode(jsonEncode(input))));
}

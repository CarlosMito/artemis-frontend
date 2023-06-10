// import 'dart:convert';
// import 'dart:async';

// import 'package:artemis/enums/image_dimension.dart';
// import 'package:artemis/models/text2image/artemis_input_api.dart';
// import 'package:artemis/models/user.dart';

// void main() {
//   // User user = User(BigInt.from(1), "test");
//   // ArtemisInputAPI(userId: user.id, prompt: "Prompt test");
//   // print(ArtemisInputAPI.fromJson(jsonDecode(jsonEncode(input))));

//   ImageDimensions imageDimensions = ImageDimensions.dim512;
//   // print(imageDimensions.toReplicateAPI());
//   print(ImageDimensions.values.byReplicateName("512x512"));
// }

// void main() async {
//   print('Before timer');

//   Duration interval = Duration(seconds: 2);

//   Future<void> periodicTask() async {
//     print('Periodic task executed');
//     // Add your logic here for the periodic task

//     // Simulate an asynchronous operation
//     await Future.delayed(Duration(seconds: 1));
//   }

//   Timer timer = Timer.periodic(interval, (_) async {
//     await periodicTask();
//   });

//   await Future.delayed(Duration(seconds: 10));

//   timer.cancel();
//   print('After timer');
// }

// ignore_for_file: avoid_print

String _removeDuplicates(String input, String target) {
  int index = input.indexOf(target);
  String substring = input.substring(index + 1);
  String replacement = substring.replaceAll(".", "");
  return input.replaceRange(index + 1, null, replacement);
}

void main() {
  print(_removeDuplicates("1.2.23.12.3123.", "."));
  print(_removeDuplicates("1...........", "."));
  print(_removeDuplicates("1.12940", "."));
  print(_removeDuplicates("1.12940.12", "."));
  print(_removeDuplicates("284038509235", "."));
}

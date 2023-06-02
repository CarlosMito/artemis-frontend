import 'package:artemis/models/text2image/artemis_input_api.dart';

class ArtemisOutputAPI {
  final ArtemisInputAPI input;
  late List<String> images;

  ArtemisOutputAPI({required this.input, images}) {
    this.images = images ?? [];
  }
}

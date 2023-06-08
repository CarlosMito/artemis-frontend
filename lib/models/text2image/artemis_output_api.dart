import 'package:artemis/models/text2image/artemis_input_api.dart';

class ArtemisOutputAPI {
  final ArtemisInputAPI input;
  final String image;
  String? title;
  String? caption;
  bool isPublic;
  int favoriteCount;

  ArtemisOutputAPI({required this.input, required this.image, this.title, this.caption, this.isPublic = false, this.favoriteCount = 0});
}

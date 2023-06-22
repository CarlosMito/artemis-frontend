import 'package:artemis/models/text2image/artemis_input_api.dart';

class ArtemisOutputAPI {
  final ArtemisInputAPI input;
  final String image;
  String? title;
  String? caption;
  bool isPublic;
  int favoriteCount;
  bool isFavorite;

  ArtemisOutputAPI({
    required this.input,
    required this.image,
    this.title,
    this.caption,
    this.isPublic = false,
    this.favoriteCount = 0,
    this.isFavorite = false,
  });

  ArtemisOutputAPI.fromJson(Map<String, dynamic> json, this.input)
      : image = json["image"],
        isPublic = json["isPublic"],
        favoriteCount = json["favoriteCount"],
        // TODO: change for the json response later
        isFavorite = false;
}

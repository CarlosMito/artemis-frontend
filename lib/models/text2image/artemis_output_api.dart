import 'package:artemis/models/text2image/artemis_input_api.dart';

class ArtemisOutputAPI {
  final BigInt id;
  final ArtemisInputAPI input;
  final String image;
  String? title;
  String? caption;
  bool isPublic;
  int favoriteCount;
  bool isFavorite;

  ArtemisOutputAPI({
    required this.id,
    required this.input,
    required this.image,
    this.title,
    this.caption,
    this.isPublic = false,
    this.favoriteCount = 0,
    this.isFavorite = false,
  });

  ArtemisOutputAPI.fromJson(Map<String, dynamic> json, this.input)
      : id = BigInt.from(json["id"]),
        image = json["image"],
        isPublic = json["isPublic"],
        favoriteCount = json["favoriteCount"],
        // TODO: change for the json response later
        isFavorite = false;

  // Map<String, String> toJson() => {
  //       "user": userId.toString(),
  //       "prompt": prompt,
  //       "negativePrompt": negativePrompt,
  //       "imageDimensions": imageDimensions.toReplicateAPI(),
  //       "numOutputs": numOutputs.toString(),
  //       "numInferenceSteps": numInferenceSteps.toString(),
  //       "guidanceScale": guidanceScale.toString(),
  //       "scheduler": scheduler.toReplicateAPI(),
  //       "seed": seed.toString(),
  //       "style": style.name,
  //       "saturation": saturation.name,
  //       "value": value.name,
  //       "colorValue": colorValue.toString(),
  //       "version": version.value,
  //     };
}

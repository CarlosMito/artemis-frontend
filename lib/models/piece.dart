import 'package:artemis/models/text2image/artemis_input_api.dart';

class DisplayPiece {
  final String image;
  final String? title;
  final String? caption;
  final ArtemisInputAPI input;
  bool isFavorite;

  DisplayPiece({
    required this.image,
    required this.input,
    this.title,
    this.caption,
    this.isFavorite = false,
  });

  String get id => image;
}

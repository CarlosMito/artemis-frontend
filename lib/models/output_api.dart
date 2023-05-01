import 'input_api.dart';

class OutputAPI {
  final InputAPI input;
  late List<String> images;

  // TODO: Change to images

  OutputAPI({required this.input, iamges}) {
    this.images = iamges ?? [];
  }
}

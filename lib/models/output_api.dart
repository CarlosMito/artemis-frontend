import 'input_api.dart';

class OutputAPI {
  final InputAPI input;
  late List<String> images;

  OutputAPI({required this.input, images}) {
    this.images = images ?? [];
  }
}

import 'input_api.dart';

class OutputAPI {
  final InputAPI input;
  late List<String> outputs;

  OutputAPI({required this.input, outputs}) {
    this.outputs = outputs ?? [];
  }
}

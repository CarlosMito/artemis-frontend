import 'package:flutter/services.dart';

class CustomRangeTextInputFormatter extends TextInputFormatter {
  double minValue;
  double maxValue;

  CustomRangeTextInputFormatter({required this.minValue, required this.maxValue});

  String _removeDuplicates(String input, String target) {
    int index = input.indexOf(target);
    String substring = input.substring(index + 1);
    String replacement = substring.replaceAll(".", "");
    return input.replaceRange(index + 1, null, replacement);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '' || newValue.text[0] == ".") {
      return const TextEditingValue();
    }

    double value = double.tryParse(newValue.text) ?? minValue;

    if (value < minValue) {
      return const TextEditingValue().copyWith(text: '1');
    }

    String newText = _removeDuplicates(newValue.text, ".");

    return value > maxValue
        ? const TextEditingValue().copyWith(
            text: maxValue.toString(),
            selection: TextSelection.fromPosition(
              TextPosition(offset: maxValue.toString().length),
            ),
          )
        : const TextEditingValue().copyWith(
            text: newText.toString(),
            selection: TextSelection.fromPosition(
              TextPosition(offset: newText.length),
            ),
          );
  }
}

import 'package:flutter/services.dart';

class CustomRangeTextInputFormatter extends TextInputFormatter {
  double minValue;
  double maxValue;

  CustomRangeTextInputFormatter({required this.minValue, required this.maxValue});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') {
      return const TextEditingValue();
    }

    if (int.parse(newValue.text) < minValue) {
      return const TextEditingValue().copyWith(text: '1');
    }

    return int.parse(newValue.text) > maxValue ? const TextEditingValue().copyWith(text: maxValue.toString()) : newValue;
  }
}

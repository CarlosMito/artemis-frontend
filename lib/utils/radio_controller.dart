import 'package:flutter/material.dart';

class RadioController {
  final List<RadioModel> radioModels;
  RadioModel? selectedModel;

  RadioController({required this.radioModels});

  void selectFirst() {
    selectedModel = radioModels.isNotEmpty ? radioModels[0] : null;
  }
}

class RadioModel<T> {
  final T value;
  final String label;
  final String? assetImage;
  final Color? backgroundColor;

  RadioModel({required this.value, required this.label, this.assetImage, this.backgroundColor});
}

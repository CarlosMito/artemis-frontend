import 'package:flutter/material.dart';

class RadioModel {
  final Object value;
  final String label;
  bool isSelected;

  RadioModel({required this.value, required this.label, this.isSelected = false});
}

class ImageRadioModel extends RadioModel {
  final String? imageUrl;
  final Color? backgroundColor;

  ImageRadioModel({required super.value, required super.label, super.isSelected, this.imageUrl, this.backgroundColor});
}

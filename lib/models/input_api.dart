import 'dart:math';

import 'package:artemis/enums/image_saturation.dart';
import 'package:artemis/enums/image_style.dart';
import 'package:artemis/enums/image_value.dart';
import 'package:flutter/material.dart';

import '../enums/scheduler.dart';
import '../enums/image_dimension.dart';

class InputAPI {
  String prompt;
  String? negativePrompt;
  late ImageDimension imageDimensions;
  late int numOutputs;
  late int numInferenceSteps;
  late double guidanceScale;
  late Scheduler scheduler;
  late int seed;

  // Post processing
  ImageStyle? style;
  ImageSaturation? saturation;
  ImageValue? value;
  Color? color;

  InputAPI({
    required this.prompt,
    numOutputs,
    guidanceScale,
    scheduler,
    imageDimensions,
    numInferenceSteps,
    seed,
    this.negativePrompt,
    this.style,
    this.saturation,
    this.value,
    this.color,
  }) {
    this.numOutputs = numOutputs ?? 1;
    this.guidanceScale = guidanceScale ?? 7.5;
    this.scheduler = scheduler ?? Scheduler.dpmSolverMultistep;
    this.imageDimensions = imageDimensions ?? ImageDimension.dim512;
    this.numInferenceSteps = numInferenceSteps ?? 50;
    this.seed = seed ?? Random().nextInt(4294967296);
  }
}

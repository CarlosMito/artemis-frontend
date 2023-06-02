import 'dart:math';

import 'package:artemis/enums/image_dimension.dart';
import 'package:artemis/enums/image_saturation.dart';
import 'package:artemis/enums/image_style.dart';
import 'package:artemis/enums/image_value.dart';
import 'package:artemis/enums/scheduler.dart';
import 'package:flutter/material.dart';

class ArtemisInputAPI {
  String prompt;
  String? negativePrompt;
  late ImageDimensions imageDimensions;
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

  ArtemisInputAPI({
    required this.prompt,
    this.style,
    this.saturation,
    this.value,
    this.color,
    this.negativePrompt,
    this.numOutputs = 1,
    this.scheduler = Scheduler.dpmSolverMultistep,
    this.guidanceScale = 7.5,
    this.numInferenceSteps = 50,
    this.imageDimensions = ImageDimensions.dim512,
    seed,
  }) {
    this.seed = seed ?? Random().nextInt(4294967296);
  }

  @override
  String toString() {
    return "ArtemisInputAPI(prompt: $prompt, negativePrompt: $negativePrompt, imageDimensions: $imageDimensions, numOutputs: $numOutputs, "
        "numInferenceSteps: $numInferenceSteps, guidanceScale: $guidanceScale, scheduler: $scheduler, seed: $seed, style: $style, "
        "saturation: $saturation, value: $value, color: $color)";
  }
}

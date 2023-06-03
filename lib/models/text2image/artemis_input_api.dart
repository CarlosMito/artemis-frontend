import 'dart:math';

import 'package:artemis/enums/image_dimension.dart';
import 'package:artemis/enums/image_saturation.dart';
import 'package:artemis/enums/image_style.dart';
import 'package:artemis/enums/image_value.dart';
import 'package:artemis/enums/scheduler.dart';

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

  // Store the integer representation of the color instead of the
  // Flutter Colors class for serialization purposes
  int colorValue;

  ArtemisInputAPI({
    required this.prompt,
    this.negativePrompt,
    this.colorValue = 0x00000000,
    this.style = ImageStyle.random,
    this.saturation = ImageSaturation.random,
    this.value = ImageValue.random,
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
        "saturation: $saturation, value: $value, color: $colorValue)";
  }

  // String prompt;
  // String? negativePrompt;
  // late ImageDimensions imageDimensions;
  // late int numOutputs;
  // late int numInferenceSteps;
  // late double guidanceScale;
  // late Scheduler scheduler;
  // late int seed;
  // ImageStyle? style;
  // ImageSaturation? saturation;
  // ImageValue? value;
  // Color? color;

  Map<String, dynamic> toJson() => {
        "prompt": prompt,
        "negativePrompt": negativePrompt,
        "imageDimensions": imageDimensions,
        "numOutputs": numOutputs,
        "numInferenceSteps": numInferenceSteps,
        "guidanceScale": guidanceScale,
        "scheduler": scheduler,
        "seed": seed,
        "style": style,
        "saturation": saturation,
        "value": value,
        "color": colorValue,
      };
}

import 'dart:math';

import 'package:artemis/enums/image_dimension.dart';
import 'package:artemis/enums/image_saturation.dart';
import 'package:artemis/enums/image_style.dart';
import 'package:artemis/enums/image_value.dart';
import 'package:artemis/enums/model_version.dart';
import 'package:artemis/enums/scheduler.dart';
import 'package:artemis/models/user.dart';

class ArtemisInputAPI {
  User user;
  String prompt;
  String negativePrompt;
  ImageDimensions imageDimensions;
  int numOutputs;
  int numInferenceSteps;
  double guidanceScale;
  Scheduler scheduler;
  StableDiffusionVersion version;
  late int seed;

  // Post processing
  ImageStyle style;
  ImageSaturation saturation;
  ImageValue value;

  // It stores the integer representation of the color instead of
  // Flutter's Color class for serialization purposes
  int colorValue;

  ArtemisInputAPI({
    required this.user,
    required this.prompt,
    this.negativePrompt = "",
    this.colorValue = 0x00000000,
    this.style = ImageStyle.random,
    this.saturation = ImageSaturation.random,
    this.value = ImageValue.random,
    this.numOutputs = 1,
    this.scheduler = Scheduler.dpmSolverMultistep,
    this.guidanceScale = 7.5,
    this.numInferenceSteps = 50,
    this.imageDimensions = ImageDimensions.dim512,
    this.version = StableDiffusionVersion.v2_1,
    seed,
  }) {
    this.seed = seed ?? Random().nextInt(4294967296);
  }

  @override
  String toString() {
    return "ArtemisInputAPI(prompt: $prompt, negativePrompt: $negativePrompt, imageDimensions: $imageDimensions, numOutputs: $numOutputs, "
        "numInferenceSteps: $numInferenceSteps, guidanceScale: $guidanceScale, scheduler: $scheduler, seed: $seed, style: $style, "
        "saturation: $saturation, value: $value, color: $colorValue, version: $version)";
  }

  // ArtemisInputAPI.fromJson(Map<String, dynamic> json)
  //     : user = json["user"],
  //       prompt = json["prompt"],
  //       negativePrompt = json["negativePrompt"],
  //       imageDimensions = ImageDimensions.values.byName(json["imageDimensions"]),
  //       numOutputs = json["numOutputs"],
  //       numInferenceSteps = json["numInferenceSteps"],
  //       guidanceScale = json["guidanceScale"],
  //       scheduler = Scheduler.values.byName(json["scheduler"]),
  //       seed = json["seed"],
  //       style = ImageStyle.values.byName(json["style"]),
  //       saturation = ImageSaturation.values.byName(json["saturation"]),
  //       value = ImageValue.values.byName(json["value"]),
  //       colorValue = json["color"];

  Map<String, String> toJson() => {
        "user": user.id.toString(),
        "prompt": prompt,
        "negativePrompt": negativePrompt,
        "imageDimensions": imageDimensions.name,
        "numOutputs": numOutputs.toString(),
        "numInferenceSteps": numInferenceSteps.toString(),
        "guidanceScale": guidanceScale.toString(),
        "scheduler": scheduler.name,
        "seed": seed.toString(),
        "style": style.name,
        "saturation": saturation.name,
        "value": value.name,
        "color": colorValue.toString(),
        "version": version.value,
      };
}

import 'dart:js_interop';
import 'dart:math';

import 'package:artemis/enums/image_dimension.dart';
import 'package:artemis/enums/image_saturation.dart';
import 'package:artemis/enums/image_style.dart';
import 'package:artemis/enums/image_value.dart';
import 'package:artemis/enums/model_version.dart';
import 'package:artemis/enums/scheduler.dart';
import 'package:artemis/models/user.dart';

class ArtemisInputAPI {
  BigInt userId;
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
    required this.userId,
    required this.prompt,
    this.negativePrompt = "",
    this.numOutputs = 1,
    this.guidanceScale = 7.5,
    this.numInferenceSteps = 50,
    this.colorValue = 0x00000000,
    this.style = ImageStyle.random,
    this.value = ImageValue.random,
    this.saturation = ImageSaturation.random,
    this.scheduler = Scheduler.dpmSolverMultistep,
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

  ArtemisInputAPI.fromJson(Map<String, dynamic> json)
      : userId = BigInt.from(json["user"]),
        prompt = json["prompt"],
        negativePrompt = json["negativePrompt"] ?? "",
        numOutputs = json["numOutputs"],
        numInferenceSteps = json["numInferenceSteps"],
        seed = json["seed"],
        colorValue = json["colorValue"],
        guidanceScale = json["guidanceScale"],
        imageDimensions = ImageDimensions.values.byName(json["imageDimensions"] ?? "dim512"),
        scheduler = Scheduler.values.byName(json["scheduler"] ?? "dpmSolverMultistep"),
        style = ImageStyle.values.byName(json["style"] ?? "random"),
        value = ImageValue.values.byName(json["value"] ?? "random"),
        saturation = ImageSaturation.values.byName(json["saturation"] ?? "random"),
        version = StableDiffusionVersion.v2_1; //""StableDiffusionVersion(json["verson"]),

  Map<String, String> toJson() => {
        "user": userId.toString(),
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

import 'package:artemis/models/scheduler.dart';

import 'image_dimension.dart';

class Prompt {
  String prompt = "";
  String? negativePrompt;
  ImageDimension imageDimensions; // Default value: 768x768
  int numOutputs;
  double guidanceScale;
  Scheduler scheduler;
  int seed;

  Prompt(this.prompt, this.negativePrompt, this.numOutputs, this.guidanceScale, this.scheduler, this.seed, this.imageDimensions);
}

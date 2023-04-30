import 'scheduler.dart';
import 'image_dimension.dart';

class InputAPI {
  String prompt;
  String? negativePrompt;
  ImageDimension? imageDimensions;
  int numOutputs;
  double guidanceScale;
  Scheduler? scheduler;
  int seed;

  InputAPI(this.prompt, this.negativePrompt, this.numOutputs, this.guidanceScale, this.scheduler, this.seed, this.imageDimensions);
}

import 'package:artemis/enums/image_dimension.dart';
import 'package:artemis/enums/image_saturation.dart';
import 'package:artemis/enums/image_style.dart';
import 'package:artemis/enums/image_value.dart';
import 'package:artemis/enums/scheduler.dart';
import 'package:artemis/models/text2image/artemis_input_api.dart';
import 'package:artemis/utils/maps.dart';
import 'package:artemis/widgets/diamond_separator.dart';
import 'package:artemis/widgets/display_image_option.dart';
import 'package:artemis/widgets/display_text_option.dart';
import 'package:flutter/material.dart';

class InputInfoListView extends StatelessWidget {
  final ArtemisInputAPI input;

  const InputInfoListView({super.key, required this.input});

  List<DisplayImageOption> buildDisplayImageOptions() {
    List<DisplayImageOption> imageOptions = [];

    imageOptions.add(DisplayImageOption(label: colorMap[input.colorValue], color: Color(input.colorValue)));
    imageOptions.add(DisplayImageOption(label: input.style.toDisplay(), imageUrl: imageMapping[input.style]));
    imageOptions.add(DisplayImageOption(label: input.saturation.toDisplay(), imageUrl: imageMapping[input.saturation]));
    imageOptions.add(DisplayImageOption(label: input.value.toDisplay(), imageUrl: imageMapping[input.value]));

    return imageOptions;
  }

  List<DisplayTextOption> buildDisplayTextOptions() {
    List<DisplayTextOption> textOptions = [];

    textOptions.add(DisplayTextOption(label: "Tamanho", minWidth: 150, value: input.imageDimensions.toReplicateAPI()));
    textOptions.add(DisplayTextOption(label: "Semente", minWidth: 150, value: input.seed.toString()));
    textOptions.add(DisplayTextOption(label: "Inferências", minWidth: 150, value: input.numInferenceSteps.toString()));
    textOptions.add(DisplayTextOption(label: "Escala de Orientação", minWidth: 150, value: input.guidanceScale.toString()));
    textOptions.add(DisplayTextOption(label: "Agendador", minWidth: 150, value: input.scheduler.toReplicateAPI()));

    return textOptions;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const DiamondSeparator(margin: EdgeInsets.symmetric(vertical: 10), widthFactor: 0.7),
        const Center(
          child: Text(
            "Visualizar",
            style: TextStyle(fontFamily: "Lexend", fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        const DiamondSeparator(margin: EdgeInsets.symmetric(vertical: 10), widthFactor: 0.7),
        const SizedBox(height: 26),
        Container(
          margin: const EdgeInsets.only(left: 12),
          child: const Text(
            "Prompts",
            style: TextStyle(
              fontFamily: "Lexend",
              fontSize: 26,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              const Row(children: [
                Flexible(
                  child: Text(
                    "Prompt Positivo",
                    style: TextStyle(
                      fontFamily: "Lexend",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                input.prompt,
                style: const TextStyle(fontFamily: "Lexend"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        if (input.negativePrompt.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Row(children: [
                  Flexible(
                    child: Text(
                      "Prompt Negativo",
                      style: TextStyle(
                        fontFamily: "Lexend",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 10),
                Text(
                  input.negativePrompt,
                  style: const TextStyle(fontFamily: "Lexend"),
                ),
              ],
            ),
          ),
        const DiamondSeparator(margin: EdgeInsets.symmetric(vertical: 40), widthFactor: 0.5),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 16,
          children: buildDisplayTextOptions(),
        ),
        const DiamondSeparator(margin: EdgeInsets.symmetric(vertical: 40), widthFactor: 0.5),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: buildDisplayImageOptions(),
        )
      ],
    );
  }
}
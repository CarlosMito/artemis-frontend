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
import 'package:flutter/services.dart';

class InputInfoListView extends StatelessWidget {
  final ArtemisInputAPI input;
  final Widget? bottomWidget;

  const InputInfoListView({super.key, required this.input, this.bottomWidget});

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
            style: TextStyle(
              fontFamily: "Lexend",
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
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
        PromptTextBlock(
          title: "Prompt",
          text: input.prompt,
        ),
        const SizedBox(height: 4),
        if (input.negativePrompt.isNotEmpty)
          PromptTextBlock(
            title: "Prompt Negativo",
            text: input.negativePrompt,
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
        ),
        if (bottomWidget != null) bottomWidget!,
      ],
    );
  }
}

class PromptTextBlock extends StatefulWidget {
  final String title;
  final String text;

  const PromptTextBlock({super.key, required this.title, required this.text});

  @override
  State<PromptTextBlock> createState() => _PromptTextBlockState();
}

class _PromptTextBlockState extends State<PromptTextBlock> {
  bool showCopyMessage = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: "Lexend",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (showCopyMessage)
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Text(
                    "Copiado!",
                    style: TextStyle(fontFamily: "Lexend"),
                  ),
                ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: widget.text));

                    setState(() {
                      showCopyMessage = true;
                    });

                    Future.delayed(const Duration(seconds: 2), () async {
                      if (context.mounted) {
                        setState(() {
                          showCopyMessage = false;
                        });
                      }
                    });

                    // NOTE: I tried using Fluttertoast, but I didn't like the result for the web (I couldn't change the font family)
                    // const snackBar = SnackBar(
                    //   content: Text(
                    //     "Copiado para a área de transferência!",
                    //     style: TextStyle(fontFamily: "Lexend"),
                    //   ),
                    //   // action: SnackBarAction(
                    //   //   label: 'Undo',
                    //   //   onPressed: () {
                    //   //     // Some code to undo the change.
                    //   //   },
                    //   // ),
                    // );

                    // ScaffoldMessenger.of(currentContext ?? context).showSnackBar(snackBar);
                  },
                  child: const Tooltip(
                    message: "Copiar",
                    waitDuration: Duration(milliseconds: 650),
                    child: Icon(
                      Icons.copy,
                      size: 22,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          SelectionArea(
            child: Text(
              widget.text,
              style: const TextStyle(
                fontFamily: "Lexend",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

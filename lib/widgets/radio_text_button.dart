import 'package:artemis/utils/radio_controller.dart';
import 'package:flutter/material.dart';

// TODO: Refactor this code in a distant future (make a common class for both RadioTextButton and RadioImageButton and implement generics)

class RadioTextButton extends StatefulWidget {
  final RadioController radioController;

  const RadioTextButton({super.key, required this.radioController});

  @override
  State<RadioTextButton> createState() => _RadioTextButtonState();
}

class _RadioTextButtonState extends State<RadioTextButton> {
  List<Widget> createRadioItems([double? width]) {
    var radioItems = <Widget>[];

    for (var radioModel in widget.radioController.radioModels) {
      radioItems.add(FittedBox(
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.radioController.selectedModel = radioModel;
            });
          },
          child: RadioItem(
            radioModel: radioModel,
            isSelected: widget.radioController.selectedModel == radioModel,
          ),
        ),
      ));
    }

    return radioItems;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: createRadioItems(),
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel radioModel;
  final bool isSelected;

  const RadioItem({super.key, required this.radioModel, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: EdgeInsets.all(isSelected ? 6 : 8),
        decoration: isSelected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color.fromARGB(255, 13, 13, 16),
                border: Border.all(
                  color: Colors.white,
                  strokeAlign: -6.0,
                ),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.transparent,
                border: Border.all(
                  color: const Color.fromARGB(255, 13, 13, 16),
                ),
              ),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            radioModel.label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

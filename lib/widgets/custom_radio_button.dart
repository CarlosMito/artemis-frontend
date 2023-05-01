import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  final List<RadioModel> radioModels;

  const CustomRadioButton({super.key, required this.radioModels});

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  List<Widget> createRadioItems([double? width]) {
    var radioItems = <Widget>[];

    for (int i = 0; i < widget.radioModels.length; i++) {
      radioItems.add(FittedBox(
        child: GestureDetector(
          onTap: () {
            setState(() {
              for (var element in widget.radioModels) {
                element.isSelected = false;
              }
              widget.radioModels[i].isSelected = true;
            });
          },
          child: RadioItem(radioModel: widget.radioModels[i]),
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

class RadioModel {
  Object value;
  bool isSelected;
  final String text;

  RadioModel(this.isSelected, this.value, this.text);
}

class RadioItem extends StatelessWidget {
  final RadioModel radioModel;

  const RadioItem({super.key, required this.radioModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(radioModel.isSelected ? 5.5 : 8),
      decoration: radioModel.isSelected
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
          radioModel.text,
          style: TextStyle(
            color: radioModel.isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
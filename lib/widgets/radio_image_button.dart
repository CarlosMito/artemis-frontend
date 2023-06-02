import 'package:artemis/models/radio_model.dart';
import 'package:flutter/material.dart';

class RadioImageButton extends StatefulWidget {
  final List<ImageRadioModel> radioModels;

  const RadioImageButton({super.key, required this.radioModels});

  @override
  State<RadioImageButton> createState() => _RadioImageButtonState();
}

class _RadioImageButtonState extends State<RadioImageButton> {
  @override
  Widget build(BuildContext context) {
    var exceptions = [null, Colors.white, Colors.transparent];

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.radioModels.length,
        separatorBuilder: (BuildContext context, int i) => const SizedBox(width: 14),
        itemBuilder: (BuildContext context, int i) {
          return GestureDetector(
            onTap: () {
              setState(() {
                for (var element in widget.radioModels) {
                  element.isSelected = false;
                }
                widget.radioModels[i].isSelected = true;
              });
            },
            child: Column(
              children: [
                ImageRadioItem(
                  radioModel: widget.radioModels[i],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.radioModels[i].label,
                  style: TextStyle(
                    fontFamily: "Lexend",
                    fontWeight: widget.radioModels[i].isSelected ? FontWeight.bold : null,
                    fontSize: 18,
                    color: widget.radioModels[i].isSelected
                        ? ((exceptions.contains(widget.radioModels[i].backgroundColor)) ? Colors.black : widget.radioModels[i].backgroundColor)
                        : Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ImageRadioItem extends StatelessWidget {
  final ImageRadioModel radioModel;

  const ImageRadioItem({super.key, required this.radioModel});

  Widget buildColorAndImageCard() {
    Color? innerColor = radioModel.backgroundColor;

    if (innerColor == null || innerColor == Colors.transparent) {
      innerColor = Colors.grey[600];
    }

    return Container(
      decoration: BoxDecoration(
        color: innerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: radioModel.assetImage != null
          ? Image.asset(
              radioModel.assetImage!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color strokeColor = radioModel.backgroundColor == Colors.white ? Colors.black : Colors.white;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        // TODO: This could be parameters
        height: 160,
        width: 160,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[600]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400]!,
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            buildColorAndImageCard(),
            if (radioModel.isSelected)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: strokeColor,
                    strokeAlign: -6,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.check,
                  color: strokeColor,
                  size: 32,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

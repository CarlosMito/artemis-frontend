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
                        ? ((exceptions.contains(widget.radioModels[i].color)) ? Colors.black : widget.radioModels[i].color)
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

class ImageRadioModel {
  final String? imageUrl;
  final Color? color;
  final String label;
  bool isSelected;

  ImageRadioModel(this.isSelected, {required this.label, this.imageUrl, this.color});
}

class ImageRadioItem extends StatelessWidget {
  final ImageRadioModel radioModel;

  const ImageRadioItem({super.key, required this.radioModel});

  Widget buildColorRadioItem() {
    if (radioModel.color == Colors.white) {
      return Container(
        decoration: BoxDecoration(
          color: radioModel.color,
          borderRadius: BorderRadius.circular(10),
          border: radioModel.isSelected
              ? Border.all(
                  color: Colors.grey[800]!,
                  strokeAlign: -6,
                  width: 2,
                )
              : null,
        ),
        child: radioModel.isSelected
            ? (Icon(
                Icons.check,
                color: Colors.grey[600]!,
                size: 32,
              ))
            : null,
      );
    }

    if (radioModel.color == Colors.transparent) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 196, 196, 196),
          border: radioModel.isSelected
              ? Border.all(
                  color: Colors.white,
                  strokeAlign: -6,
                  width: 2,
                )
              : null,
        ),
        child: const Icon(
          Icons.question_mark_outlined,
          color: Colors.white,
          size: 32,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: radioModel.color,
        border: radioModel.isSelected
            ? Border.all(
                color: Colors.white,
                strokeAlign: -6,
                width: 2,
              )
            : null,
      ),
      child: radioModel.isSelected
          ? (const Icon(
              Icons.check,
              color: Colors.white,
              size: 32,
            ))
          : null,
    );
  }

  Widget buildImageRadioItem() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            radioModel.imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: radioModel.isSelected
                ? Border.all(
                    color: Colors.white,
                    strokeAlign: -6,
                    width: 2,
                  )
                : null,
          ),
          child: radioModel.isSelected
              ? (const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 32,
                ))
              : null,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
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
              offset: const Offset(3, 3), // changes position of shadow
            ),
          ],
        ),
        child: radioModel.imageUrl == null ? buildColorRadioItem() : buildImageRadioItem(),
      ),
    );
  }
}

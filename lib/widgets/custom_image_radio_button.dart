import 'package:flutter/material.dart';

class CustomImageRadioButton extends StatefulWidget {
  final List<ImageRadioModel> radioModels;

  const CustomImageRadioButton({super.key, required this.radioModels});

  @override
  State<CustomImageRadioButton> createState() => _CustomImageRadioButtonState();
}

class _CustomImageRadioButtonState extends State<CustomImageRadioButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.radioModels.length,
        separatorBuilder: (BuildContext context, int i) => const SizedBox(width: 10.0),
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
            child: SizedBox(
              child: Column(
                children: [
                  ImageRadioItem(
                    radioModel: widget.radioModels[i],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    widget.radioModels[i].label,
                    style: TextStyle(
                      fontFamily: "Lexend",
                      fontWeight: widget.radioModels[i].isSelected ? FontWeight.bold : null,
                      color: widget.radioModels[i].isSelected
                          ? ((widget.radioModels[i].color == null || widget.radioModels[i].color == Colors.white)
                              ? Colors.black
                              : widget.radioModels[i].color)
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
          ;
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
    if (radioModel.color != Colors.white) {
      return Container(
        height: 130.0,
        width: 130.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: radioModel.color,
          border: radioModel.isSelected
              ? Border.all(
                  color: Colors.white,
                  strokeAlign: -6.0,
                  width: 2.0,
                )
              : null,
        ),
        child: radioModel.isSelected
            ? (const Icon(
                Icons.check,
                color: Colors.white,
                size: 32.0,
              ))
            : null,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Container(
        height: 130.0,
        width: 130.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: radioModel.color,
          border: radioModel.isSelected
              ? Border.all(
                  color: Colors.grey[800]!,
                  strokeAlign: -6.0,
                  width: 2.0,
                )
              : null,
        ),
        child: radioModel.isSelected
            ? (Icon(
                Icons.check,
                color: Colors.grey[800]!,
                size: 32.0,
              ))
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildColorRadioItem();
    // Container(
    //   padding: EdgeInsets.all(radioModel.isSelected ? 5.5 : 8),
    //   decoration: radioModel.isSelected
    //       ? BoxDecoration(
    //           borderRadius: BorderRadius.circular(4),
    //           color: const Color.fromARGB(255, 13, 13, 16),
    //           border: Border.all(
    //             color: Colors.white,
    //             strokeAlign: -6.0,
    //           ),
    //         )
    //       : BoxDecoration(
    //           borderRadius: BorderRadius.circular(4),
    //           color: Colors.transparent,
    //           border: Border.all(
    //             color: const Color.fromARGB(255, 13, 13, 16),
    //           ),
    //         ),
    //   alignment: Alignment.center,
    //   child: Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
    //     child: Text(
    //       radioModel.label,
    //       style: TextStyle(
    //         color: radioModel.isSelected ? Colors.white : Colors.black,
    //       ),
    //     ),
    //   ),
    // );
  }
}

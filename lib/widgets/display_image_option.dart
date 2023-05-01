import 'package:flutter/material.dart';

class DisplayImageOption extends StatelessWidget {
  final String? label;
  final Color? color;
  final String? imageUrl;

  const DisplayImageOption({super.key, required this.label, this.color, this.imageUrl});

  Widget buildChild() {
    return color == null
        ? Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : Container(color: color);
  }

  @override
  Widget build(BuildContext context) {
    if (color == null && imageUrl == null) return Container();

    return Column(
      children: [
        Container(
          height: 120,
          width: 120,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[600]!),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(3, 3), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: buildChild(),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white,
                    strokeAlign: -5,
                    width: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label ?? "",
          style: const TextStyle(fontFamily: "Lexend"),
        ),
      ],
    );
  }
}

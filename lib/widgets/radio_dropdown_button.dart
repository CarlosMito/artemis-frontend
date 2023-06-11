import 'package:artemis/utils/radio_controller.dart';
import 'package:flutter/material.dart';

class RadioDropdownButton extends StatefulWidget {
  final RadioController controller;

  const RadioDropdownButton({super.key, required this.controller});

  @override
  State<RadioDropdownButton> createState() => _RadioDropdownButtonState();
}

class _RadioDropdownButtonState extends State<RadioDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: SizedBox(
          height: 16,
          child: DropdownButton<dynamic>(
            value: widget.controller.selectedModel?.value,
            isExpanded: true,
            isDense: true,
            icon: const Icon(Icons.arrow_drop_down),
            style: const TextStyle(color: Colors.black),
            onChanged: (dynamic value) {
              setState(() {
                widget.controller.selectTarget(value);
              });
            },
            items: widget.controller.radioModels.map<DropdownMenuItem<dynamic>>((RadioModel<dynamic> model) {
              return DropdownMenuItem<dynamic>(
                value: model.value,
                child: Text(model.label),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

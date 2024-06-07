import 'package:flutter/material.dart';

class TextFormFieldPage extends StatelessWidget {
  final TextEditingController controllerType;
  final String? Function(String?)? validator;
  final String labelText;
  final void Function(String)? buttonAction;
  const TextFormFieldPage(
      {super.key,
      required this.controllerType,
      required this.labelText,
      this.validator,
      this.buttonAction});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(labelText),
      ),
      validator: validator,
      onChanged: buttonAction,
    );
  }
}

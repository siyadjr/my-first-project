import 'package:flutter/material.dart';

class TextFormFieldPage extends StatefulWidget {
  final TextEditingController controllerType;
  final String? Function(String?)? validator;
  final String labelText;
  final void Function(String)? buttonAction;
  final bool? obscureText;
  final TextInputType? type;
  final Widget? suffixIcon;
  final int? maxlength;
  final int? maxLine;
  final Widget? prefixIcon;
  const TextFormFieldPage(
      {super.key,
      required this.controllerType,
      required this.labelText,
      this.validator,
      this.buttonAction,
      this.obscureText,
      this.type,
      this.suffixIcon,
      this.maxlength,
      this.maxLine,
      this.prefixIcon});

  @override
  _TextFormFieldPageState createState() => _TextFormFieldPageState();
}

class _TextFormFieldPageState extends State<TextFormFieldPage> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          maxLines: widget.maxLine,
          maxLength: widget.maxlength ?? null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: widget.type ?? TextInputType.name,
          controller: widget.controllerType,
          obscureText: _obscureText,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            border: const OutlineInputBorder(),
            label: Text(widget.labelText),
            suffixIcon: widget.suffixIcon ??
                (widget.obscureText == true
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null),
          ),
          validator: widget.validator,
          onChanged: widget.buttonAction,
        ),
      ],
    );
  }
}

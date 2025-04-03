import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:split_trip/constants/theme_constants.dart';

import '../../../utilities/animated_text.dart';

OutlineInputBorder borderActive = OutlineInputBorder(borderSide: const BorderSide(color: mainColor), borderRadius: BorderRadius.circular(10));
OutlineInputBorder borderInActive = OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(232, 232, 234, 1)), borderRadius: BorderRadius.circular(10));

class PasswordInput extends StatefulWidget {
  final String hint;
  final TextEditingController? textEditingController;
  final String? errorText;
  final String name;
  final Map<String, dynamic>? formData;
  final String? initialValue;

  const PasswordInput({
    super.key,
    required this.name,
    required this.formData,
    required this.hint,
    this.errorText,
    this.initialValue,
    this.textEditingController
  });

  @override
  State<PasswordInput> createState() => PasswordInputState();
}

class PasswordInputState extends State<PasswordInput> {
  bool obscureText = true;
  final FocusNode focus = FocusNode();
  bool focused = false;

  void setVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    focus.addListener(() {
      setState(() {
        focused = !focused;
      });
    });

    if (widget.initialValue != null) {
      widget.formData?[widget.name] = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.hint.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.hint,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
          ),
        SizedBox(
          height: cTextFormFieldHeight,
          child: TextFormField(
            focusNode: focus,
            controller: widget.textEditingController,
            obscureText: obscureText,
            onChanged: (String value) {
              widget.formData![widget.name] = value;
            },
            onSaved: (String? value) {
              widget.formData![widget.name] = value;
            },
            initialValue: widget.initialValue,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: obscureText ? SvgPicture.asset('assets/images/unvisible.svg') : SvgPicture.asset('assets/images/visible.svg'),
                onPressed: setVisibility,
              ),
              hintText: widget.hint,
              hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: cTextFormFieldHintFontSize),
              border: borderActive,
              enabledBorder: borderInActive,
              focusedBorder: borderActive,
              errorBorder: borderActive,
            ),
          ),
        ),
        AnimatedText(text: widget.errorText)
      ],
    );
  }
}

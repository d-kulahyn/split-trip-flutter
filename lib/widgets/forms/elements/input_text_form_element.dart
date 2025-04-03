import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_trip/constants/theme_constants.dart';
import 'package:split_trip/enums/category_enum.dart';
import 'package:split_trip/utilities/animated_text.dart';

OutlineInputBorder borderActive = OutlineInputBorder(borderSide: const BorderSide(color: cBorderActiveColor), borderRadius: cInputBorderRadius);
OutlineInputBorder borderInActive = OutlineInputBorder(borderSide: const BorderSide(color: cBorderInactiveColor), borderRadius: cInputBorderRadius);

class TextFormInput extends StatefulWidget {
  final String hintText;
  final TextEditingController? textEditingController;
  final String name;
  final Map<String, dynamic>? formData;
  final String? initialValue;
  final String? label;
  final double? width;
  final double fontSize;
  final EdgeInsets? contentPadding;
  final CategoryEnum? suffixIcon;
  final Function? suffixIconCallback;
  final String? errorText;
  final TextInputType? keyboardType;
  final Color? iconColor;
  final double? height;
  final FocusNode? focus;
  final List<TextInputFormatter>? formatters;
  final Function(String)? onChanged;

  const TextFormInput(
      {super.key,
      required this.name,
      this.formData,
      this.focus,
      required this.hintText,
      this.initialValue,
      this.label,
      this.formatters,
      this.width,
      this.fontSize = cTextFormFieldFontSize,
      this.contentPadding,
      this.suffixIcon,
      this.suffixIconCallback,
      this.iconColor,
      this.keyboardType,
      this.height,
      this.errorText,
      this.onChanged,
      this.textEditingController});

  @override
  State<TextFormInput> createState() => TextFormInputState();
}

class TextFormInputState extends State<TextFormInput> {

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      widget.formData?[widget.name] = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.hintText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
          ),
        SizedBox(
          width: widget.width,
          height: widget.height ?? cTextFormFieldHeight,
          child: TextFormField(
            inputFormatters: widget.formatters,
            onChanged: widget.onChanged ?? (String value) {
              widget.formData?[widget.name] = value;
            },
            maxLines: null,
            keyboardType: widget.keyboardType,
            expands: true,
            controller: widget.textEditingController,
            focusNode: widget.focus,
            onSaved: (String? value) {
              widget.formData?[widget.name] = value;
            },
            initialValue: widget.initialValue,
            style: TextStyle(fontSize: widget.fontSize),
            decoration: InputDecoration(
              suffixIcon: widget.suffixIcon != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        IconButton(
                          icon: Icon(
                            widget.suffixIcon?.icon,
                            color: widget.iconColor ?? Colors.green,
                          ),
                          onPressed: () {
                            if (widget.suffixIconCallback != null) {
                              widget.suffixIconCallback!();
                            }
                          },
                        ),
                      ],
                    )
                  : null,
              hintText: widget.hintText,
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

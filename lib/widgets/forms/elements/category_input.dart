import 'package:flutter/material.dart';

import '../../../enums/category_enum.dart';
import 'input_text_form_element.dart';

class CategoryInput extends StatefulWidget {
  final Map<String, dynamic> formData;
  final String name;
  final String hintText;
  final Function? selected;
  final String? categoryErrorText;
  final String? descriptionErrorText;
  final String? initialValue;
  final String? category;

  const CategoryInput(
      {super.key,
      this.selected,
      required this.hintText,
      this.categoryErrorText,
      this.descriptionErrorText,
      this.initialValue,
      this.category,
      required this.name,
      required this.formData});

  @override
  State<CategoryInput> createState() => _CategoryInputState();
}

class _CategoryInputState extends State<CategoryInput> {
  CategoryEnum? suffixIcon = CategoryEnum.other;

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      suffixIcon = CategoryEnum.fromString(widget.category!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormInput(
        errorText: widget.categoryErrorText ?? widget.descriptionErrorText,
        name: widget.name,
        formData: widget.formData,
        hintText: widget.hintText,
        initialValue: widget.initialValue,
        iconColor: widget.categoryErrorText != null ? Colors.red : Colors.green,
        onChanged: (String value) {
          widget.formData[widget.name] = value;
        }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:split_trip/widgets/modals/category_modal.dart';

import '../constants/theme_constants.dart';
import '../enums/category_enum.dart';
import '../utilities/animated_text.dart';
import 'modals/modal_bottom_sheet.dart';

class CategoryWidget extends StatefulWidget {
  final Function? onSelected;
  final String? error;
  final String? initialCategory;

  const CategoryWidget({super.key, this.onSelected, this.initialCategory, this.error});

  @override
  State<CategoryWidget> createState() => CategoryWidgetState();
}

class CategoryWidgetState extends State<CategoryWidget> {
  late CategoryEnum category;

  @override
  void initState() {
    super.initState();
    category = widget.initialCategory != null ? CategoryEnum.fromString(widget.initialCategory!) : CategoryEnum.other;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Choose a category',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final result = await modalBottomSheet<CategoryEnum>(context, CategoryModal(selectedCategory: category.label));
            if (result != null) {
              widget.onSelected!(result);
              setState(() {
                category = result;
              });
            }
          },
          child: Container(
            height: cTextFormFieldHeight,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: cBorderInactiveColor,
                ),
                borderRadius: cInputBorderRadius),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(category.icon),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      category.label,
                      style: const TextStyle(
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                )
              ],
            ),
          ),
        ),
        AnimatedText(text: widget.error),
      ],
    );
  }
}

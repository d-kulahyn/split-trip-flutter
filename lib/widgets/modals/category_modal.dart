import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:split_trip/enums/category_enum.dart';
import 'package:split_trip/widgets/forms/elements/input_text_form_element.dart';

class CategoryModal extends StatefulWidget {
  final String? selectedCategory;

  const CategoryModal({super.key, this.selectedCategory});

  @override
  State<CategoryModal> createState() => CategoryModalState();
}

class CategoryModalState extends State<CategoryModal> {
  final TextEditingController textEditingController = TextEditingController();

  List<CategoryEnum> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    filteredCategories = CategoryEnum.values;
    textEditingController.addListener(() {
      setState(() {
        filteredCategories = CategoryEnum.values.where((category) => category.label.toLowerCase().contains(textEditingController.text.toLowerCase())).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.95,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const Text(
                    'Choose category',
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormInput(
                textEditingController: textEditingController,
                name: 'category',
                hintText: 'Type for searching...',
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => const Divider(
                  height: 1,
                  thickness: 1,
                ),
                itemCount: filteredCategories.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (widget.selectedCategory != null && widget.selectedCategory == filteredCategories[index].label) SvgPicture.asset('assets/images/check.svg'),
                          const SizedBox(width: 10),
                          Icon(filteredCategories[index].icon),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, filteredCategories[index]);
                    },
                    title: Text(filteredCategories[index].label),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

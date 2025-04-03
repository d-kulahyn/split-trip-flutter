import 'package:flutter/material.dart';
import 'package:split_trip/widgets/category_widget.dart';

import '../enums/category_enum.dart';
import 'currency_widget.dart';
import 'forms/elements/input_text_form_element.dart';

class GroupEdit extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Map<String, dynamic>? additional;
  final Map<String, dynamic> errors;

  const GroupEdit({super.key, required this.formData, required this.errors, this.additional});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormInput(
                errorText: errors['name'],
                name: 'name',
                formData: formData,
                label: 'Name',
                hintText: 'Name',
                initialValue: formData['name'],
                onChanged: (String value) {
                  formData['name'] = value;
                },
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: CategoryWidget(
            error: errors['category'],
            initialCategory: formData['category'],
            onSelected: (CategoryEnum category) {
              formData['category'] = category.label;
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: CurrencyWidget(
            error: errors['currency'],
            initialCurrency: formData['finalCurrency'],
            currencies: additional?['currencies'] ?? [],
            onSelected: (String currency) {
              formData['currency'] = currency;
            },
          ),
        ),
      ],
    );
  }
}

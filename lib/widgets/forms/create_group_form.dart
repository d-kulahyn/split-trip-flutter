import 'package:flutter/material.dart';
import 'package:split_trip/constants/theme_constants.dart';

import '../../enums/category_enum.dart';
import '../../models/group_model.dart';
import '../currency_widget.dart';
import 'elements/category_input.dart';

class CreateGroupForm extends StatefulWidget {
  final GlobalKey formKey;
  final Map<String, dynamic> formData;
  final String? categoryErrorText;
  final String? mainErrorText;
  final List<dynamic> currencies;
  final GroupModel? group;

  const CreateGroupForm({
    super.key,
    required this.formKey,
    required this.formData,
    required this.currencies,
    this.categoryErrorText,
    this.mainErrorText,
    this.group
  });

  @override
  State<CreateGroupForm> createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: cTextFormFieldGeneralHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CategoryInput(
                    hintText: 'Name',
                    name: 'name',
                    initialValue: widget.group?.name,
                    category: widget.group?.category,
                    categoryErrorText: widget.categoryErrorText,
                    descriptionErrorText: widget.mainErrorText,
                    formData: widget.formData,
                    selected: (CategoryEnum category) {
                      widget.formData['category'] = category.label;
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  height: cTextFormFieldHeight,
                  alignment: Alignment.center,
                  child: CurrencyWidget(
                    initialCurrency: widget.group?.finalCurrency,
                    currencies: widget.currencies,
                    onSelected: (String currency) {
                      widget.formData['currency'] = currency;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:split_trip/utilities/animated_text.dart';

import '../constants/theme_constants.dart';
import '../models/user_model.dart';
import 'modals/expense_user_modal.dart';
import 'modals/modal_bottom_sheet.dart';
import '../utilities/currency_extension.dart';
import 'package:decimal/decimal.dart';

class ExpenseUsersPicker extends StatefulWidget {
  final List<UserModel> users;
  final Map<String, dynamic>? data;
  final String? field;
  final String? hintText;
  final String? inputHintText;
  final bool splitActions;
  final bool showCurrency;
  final String? errorText;
  final String? title;
  final double? maxAmount;
  final String? totalField;
  final Map<String, dynamic>? rates;
  final List<dynamic> currencies;
  final Function? callback;

  const ExpenseUsersPicker(
      {super.key,
      required this.users,
      this.data,
      this.field,
      this.hintText,
      this.errorText,
      this.maxAmount,
      this.title,
      this.rates,
      this.totalField,
      this.callback,
      bool? splitActions,
      this.inputHintText,
      bool? showCurrency,
      required this.currencies})
      : splitActions = splitActions ?? true,
        showCurrency = showCurrency ?? true;

  @override
  State<ExpenseUsersPicker> createState() => _ExpenseUsersPickerState();
}

class _ExpenseUsersPickerState extends State<ExpenseUsersPicker> {
  List selectedUsers = [];

  @override
  void initState() {
    super.initState();
  }

  void calculateTotal(List? data) {
    Decimal amount = Decimal.parse('0.00');
    if (data != null) {
      List result = data.map((selectedUser) {
        Decimal value = Decimal.parse(selectedUser['amount']?.toString() ?? '0.0');
        if (widget.showCurrency && widget.rates!.isNotEmpty && selectedUser['currency'] != widget.data!['currency']) {
          value = (Decimal.parse(value.toString()) / Decimal.parse(widget.rates![selectedUser['currency']].toString())).toDecimal(scaleOnInfinitePrecision: 2);
        }

        amount += value;
        return selectedUser;
      }).toList();

      if (widget.data != null && widget.field != null) {
        widget.data![widget.field!] = result;
      }

      setState(() {
        selectedUsers = result;
      });
    }

    setState(() {
      if (widget.totalField != null) {
        widget.data?[widget.totalField!] = amount.toDouble();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final List? data = await modalBottomSheet(
          context,
          ExpenseUserModal(
            title: widget.title,
            maxAmount: widget.maxAmount,
            currencies: widget.currencies,
            users: widget.users,
            currency: widget.data?['currency'],
            hintText: widget.inputHintText,
            data: (widget.data?[widget.totalField] ?? 0) > 0
                ? widget.data![widget.field]
                : null,
            splitActions: widget.splitActions,
            showCurrency: widget.showCurrency,
          ),
        );
        calculateTotal(data);
        if (widget.callback != null) {
          widget.callback!();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(
              minHeight: cTextFormFieldHeight
            ),
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border.all(
                color: cBorderInactiveColor,
              ),
              borderRadius: cInputBorderRadius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    selectedUsers.isNotEmpty && (widget.data?[widget.totalField] ?? 0) > 0
                        ? Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: -15,
                                clipBehavior: Clip.none,
                                children: selectedUsers.map((user) {
                                  return CircleAvatar(
                                    backgroundImage: user['avatar'] != null ? NetworkImage(user['avatar']) : const AssetImage('assets/images/avatar.jpg'),
                                    radius: 15,
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        : Text(
                            widget.hintText ?? '',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: cTextFormFieldHintFontSize,
                            ),
                          ),
                    const SizedBox(width: 10),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 5,
                      children: [
                        Text(
                          CurrencyHelper.format(widget.data?[widget.totalField] ?? 0.00),
                          style: const TextStyle(color: Colors.indigo),
                        ),
                        Text(
                          widget.data!['currency'],
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          AnimatedText(
            text: widget.errorText,
          ),
        ],
      ),
    );
  }
}

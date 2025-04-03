import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_trip/models/auth_model.dart';
import 'package:split_trip/utilities/currency_extension.dart';
import 'package:split_trip/widgets/currency_widget.dart';
import 'package:split_trip/widgets/decimal_text_input_formatter.dart';
import 'package:split_trip/widgets/forms/elements/input_text_form_element.dart';
import 'package:split_trip/widgets/max_value_text_input_formatter.dart';
import 'package:split_trip/widgets/shake_widget.dart';

import '../../constants/theme_constants.dart';
import '../../models/user_model.dart';
import '../arrow_back.dart';

class ExpenseUserModal extends StatefulWidget {
  final List<UserModel> users;
  final String? hintText;
  final String? currency;
  final String? title;
  final List<dynamic>? data;
  final bool splitActions;
  final bool showCurrency;
  final double? maxAmount;
  final List<dynamic> currencies;

  const ExpenseUserModal({
    super.key,
    required this.users,
    this.hintText,
    this.data,
    this.maxAmount,
    this.title,
    this.currency,
    required this.splitActions,
    required this.showCurrency,
    required this.currencies,
  });

  @override
  State<ExpenseUserModal> createState() => ExpenseUserModalState();
}

class ExpenseUserModalState extends State<ExpenseUserModal> {
  final TextEditingController textEditingController = TextEditingController();

  List filteredUsers = [];
  List localUsers = [];
  UniqueKey animationKey = UniqueKey();

  double get textAmount {
    final Decimal maxAmount = Decimal.parse((widget.maxAmount ?? 0.0).toString());

    final Decimal totalUsed = filteredUsers.fold<Decimal>(
      Decimal.zero,
      (sum, user) => sum + (user['visibility'] ? Decimal.parse((user['amount'] ?? 0).toString()) : Decimal.zero),
    );

    final Decimal amount = maxAmount - totalUsed;

    return amount.toDouble();
  }

  List get validUsers => filteredUsers.where((user) => (user['amount'] ?? 0) > 0 && user['visibility']).toList();

  @override
  void initState() {
    super.initState();

    fillFilteredUsers();

    textEditingController.addListener(() {
      setState(() {
        filteredUsers = localUsers.where((user) => user['name'].toLowerCase().contains(textEditingController.text.toLowerCase())).toList();
      });
    });
  }

  void fillFilteredUsers() {
    filteredUsers = localUsers = widget.users.map((UserModel user) {
      final selectedUser = (widget.data ?? []).firstWhere((su) => su['id'] == user.id, orElse: () => {}) ?? {};

      final controller = TextEditingController(
        text: selectedUser.isNotEmpty ? CurrencyHelper.format(selectedUser['amount']) : '',
      );

      return {
        'id': user.id,
        'name': user.name,
        'avatar': user.avatar,
        'visibility': selectedUser.isNotEmpty,
        'amount': selectedUser['amount'],
        'controller': controller,
        'currency': selectedUser['currency'] ?? widget.currency,
        'focusNode': FocusNode(),
      };
    }).toList();
  }

  void triggerShake() {
    setState(() {
      animationKey = UniqueKey();
    });
  }

  void splitAmountEqually() {
    final double amount = (Decimal.parse(widget.maxAmount!.toString()) / Decimal.parse(filteredUsers.length.toString())).toDecimal(scaleOnInfinitePrecision: 2).toDouble();

    final random = Random().nextInt(filteredUsers.length);

    filteredUsers.asMap().forEach((index, user) {
      user['amount'] = amount;
      user['visibility'] = true;
      user['controller'].text = amount.toString();
    });

    if (textAmount != 0) {
      filteredUsers[random]['amount'] = (Decimal.parse(filteredUsers[random]['amount'].toString()) + Decimal.parse(textAmount.toString())).toDouble();
      filteredUsers[random]['controller'].text = CurrencyHelper.format(filteredUsers[random]['amount']);
    }

    setState(() {
      // trigger textAmount updating
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    filteredUsers.asMap().forEach((index, user) => user['controller'].dispose);
    localUsers.asMap().forEach((index, user) => user['controller'].dispose);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.95,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const ArrowBack(),
                ),
                Text(widget.title ?? ''),
                TextButton(
                  onPressed: () {
                    if (widget.maxAmount != null && textAmount != 0) {
                      triggerShake();

                      return;
                    }

                    Navigator.pop(context, validUsers);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: TextFormInput(
                          textEditingController: textEditingController,
                          name: 'user',
                          hintText: 'Type for searching users...',
                        ),
                      ),
                      Visibility(
                        visible: widget.splitActions,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: cTextFormFieldHeight,
                                    decoration: BoxDecoration(
                                      borderRadius: cInputBorderRadius,
                                      color: const Color.fromRGBO(242, 238, 255, 1),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        if (widget.maxAmount != null) {
                                          splitAmountEqually();
                                        }
                                      },
                                      child: const Text(
                                        'Split equally',
                                        style: TextStyle(
                                          color: Color.fromRGBO(150, 123, 254, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: filteredUsers
                              .map(
                                (user) => Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              user['visibility'] = !user['visibility'];
                                              for (var user in filteredUsers) {
                                                user['focusNode'].unfocus();
                                              }
                                              if (user['visibility']) {
                                                user['focusNode'].requestFocus();
                                              }
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.only(left: 10),
                                            margin: const EdgeInsets.only(left: 5),
                                            height: cTextFormFieldHeight,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: cInputBorderRadius,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.05),
                                                  offset: const Offset(0, 0),
                                                  blurRadius: 5,
                                                  spreadRadius: 0,
                                                )
                                              ],
                                            ),
                                            child: Wrap(
                                              spacing: 5,
                                              crossAxisAlignment: WrapCrossAlignment.center,
                                              children: [
                                                Visibility(
                                                  visible: user['visibility'],
                                                  child: const Icon(
                                                    Icons.check_circle,
                                                    color: mainColor,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                CircleAvatar(
                                                  radius: 15,
                                                  backgroundImage: user['avatar'] != null ? NetworkImage(user['avatar']) : const AssetImage('assets/images/avatar.jpg'),
                                                ),
                                                Text(context.read<AuthModel>().user!.id == user['id'] ? 'Me' : user['name'] ?? ''),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Visibility(
                                        visible: user['visibility'],
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              // margin: const EdgeInsets.only(left: 5),
                                              decoration: const BoxDecoration(color: Colors.white),
                                              child: TextFormInput(
                                                width: 100,
                                                formatters: [DecimalTextInputFormatter(decimalRange: 2), MaxValueTextInputFormatter(10000000)],
                                                focus: user['focusNode'],
                                                textEditingController: user['controller'],
                                                onChanged: (String value) {
                                                  double localValue = double.parse(value.isEmpty ? '0' : value);
                                                  setState(() {
                                                    user['amount'] = localValue;
                                                  });
                                                },
                                                keyboardType: TextInputType.number,
                                                name: "paid-${user['id']}",
                                                hintText: widget.hintText ?? '',
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              // height: cTextFormFieldHeight,
                                              alignment: Alignment.center,
                                              child: CurrencyWidget(
                                                visibleLabel: false,
                                                showIcon: false,
                                                currencies: widget.currencies,
                                                initialCurrency: user['currency'],
                                                onSelected: (String currency) {
                                                  user['currency'] = currency;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.maxAmount != null,
                  child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ShakeWidget(
                      key: animationKey,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.maxAmount == null ? '' : 'Total left: ${CurrencyHelper.format(textAmount)} ${widget.currency}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textAmount >= 0 ? Colors.green : Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
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

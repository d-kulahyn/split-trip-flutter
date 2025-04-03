import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_trip/constants/theme_constants.dart';
import 'package:split_trip/models/group_model.dart';
import 'package:split_trip/repositories/currency_repository.dart';
import 'package:split_trip/services/request_service.dart';
import 'package:split_trip/widgets/currency_widget.dart';
import 'package:split_trip/widgets/date_picker.dart';
import 'package:split_trip/widgets/expense_users_picker.dart';
import 'package:split_trip/widgets/future_result_builder.dart';
import '../../enums/category_enum.dart';
import '../category_widget.dart';
import 'elements/input_text_form_element.dart';

class AddExpenseForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Map<String, dynamic>? additional;
  final Map<String, dynamic> errors;

  AddExpenseForm({super.key, required this.formData, required this.errors, this.additional})
      : assert(additional != null && additional.containsKey("group") && additional["group"] is GroupModel, "additional group must be set");

  @override
  State<AddExpenseForm> createState() => AddExpenseFormState();
}

class AddExpenseFormState extends State<AddExpenseForm> {
  IconData? suffixIcon = CategoryEnum.other.icon;
  final formKey = GlobalKey<FormState>();

  Map<String, dynamic>? rates = {};

  late Future<Map<String, dynamic>> futureRates;

  @override
  void initState() {
    super.initState();
    futureRates = fetchRates();
  }

  Future<Map<String, dynamic>> fetchRates() async {
    final currencyRepository = context.read<CurrencyRepository>();

    Map<String, dynamic> result = {};

    await RequestService.send(
      context,
      currencyRepository.rates(widget.formData['currency']),
      onSuccess: (Map<String, dynamic> responseRates) {
        result = responseRates;
        if (widget.formData['totalPays'] != null && widget.formData['beforeCurrency'] != null) {
          final double currentRate = result[widget.formData['beforeCurrency']];
          final double totalPays = widget.formData['totalPays'];
          widget.formData['totalPays'] = (Decimal.parse(totalPays.toString()) / Decimal.parse(currentRate.toString())).toDecimal(scaleOnInfinitePrecision: 2).toDouble();
          widget.formData['totalDebts'] = 0.00;
        }
      },
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureResultBuilder<Map<String, dynamic>>(
      future: futureRates,
      onSuccess: (BuildContext context, Map<String, dynamic> rates) {
        return Wrap(
          runSpacing: 10,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormInput(
                    hintText: 'Description',
                    name: 'description',
                    errorText: widget.errors["description"],
                    formData: widget.formData,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CurrencyWidget(
                  visibleLabel: false,
                  showIcon: false,
                  initialCurrency: widget.formData['finalCurrency'],
                  currencies: widget.additional!["group"].currencies ?? [],
                  onSelected: (String currency) {
                    widget.formData['beforeCurrency'] = widget.formData['currency'];
                    widget.formData['currency'] = currency;
                    // fetchRates();
                  },
                ),
              ],
            ),
            CategoryWidget(
              error: widget.errors['category'],
              initialCategory: widget.formData['category'],
              onSelected: (CategoryEnum category) {
                widget.formData['category'] = category.label;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ExpenseUsersPicker(
                    title: "Payer(s)",
                    currencies: widget.additional!["group"].currencies,
                    rates: rates,
                    splitActions: false,
                    inputHintText: 'payed',
                    users: widget.additional!["group"].members,
                    errorText: widget.errors['payers'],
                    data: widget.formData,
                    field: 'payers',
                    totalField: 'totalPays',
                    hintText: 'Choose who paid...',
                    callback: () {
                      setState(() {
                        widget.formData['totalDebts'] = 0.00;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  height: cTextFormFieldHeight,
                  child: DatePicker(
                    callback: (date) {
                      widget.formData['created_at'] = date;
                    },
                  ),
                ),
              ],
            ),
            ExpenseUsersPicker(
              currencies: widget.additional!["group"].currencies,
              showCurrency: false,
              inputHintText: 'owes',
              users: widget.additional!["group"].members,
              data: widget.formData,
              totalField: 'totalDebts',
              maxAmount: widget.formData['totalPays'],
              errorText: widget.errors['debtors'],
              field: 'debtors',
              hintText: 'Choose who owes...',
            ),
          ],
        );
      },
    );
  }
}

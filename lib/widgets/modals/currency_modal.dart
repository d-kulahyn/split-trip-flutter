import 'package:flutter/material.dart';
import 'package:split_trip/widgets/forms/elements/input_text_form_element.dart';

class CurrencyModal extends StatefulWidget {
  final List<dynamic> currencies;

  const CurrencyModal({super.key, required this.currencies});

  @override
  State<CurrencyModal> createState() => _CurrencyModalState();
}

class _CurrencyModalState extends State<CurrencyModal> {
  final TextEditingController textEditingController = TextEditingController();

  List<dynamic> filteredCurrencies = [];

  @override
  void initState() {
    super.initState();
    filteredCurrencies = widget.currencies;

    textEditingController.addListener(() {
      setState(() {
        filteredCurrencies = widget.currencies.where((currency) => currency[0].toLowerCase().contains(textEditingController.text.toLowerCase())).toList();
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
                    'Choose currency',
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormInput(
                textEditingController: textEditingController,
                name: 'currency',
                hintText: 'Type for searching...',
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemCount: filteredCurrencies.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    dense: true,
                    onTap: () {
                      Navigator.pop(context, filteredCurrencies[index][0]);
                    },
                    title: Row(
                      children: [
                        Text(filteredCurrencies[index][0]),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(filteredCurrencies[index][1]),
                        ),
                      ],
                    ),
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

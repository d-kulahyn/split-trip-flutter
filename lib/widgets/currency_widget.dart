import 'package:flutter/material.dart';

import '../constants/theme_constants.dart';
import '../utilities/animated_text.dart';
import 'modals/currency_modal.dart';
import 'modals/modal_bottom_sheet.dart';

class CurrencyWidget extends StatefulWidget {
  final Function? onSelected;
  final String? initialCurrency;
  final String? error;
  final bool visibleLabel;
  final bool showIcon;
  final List<dynamic> currencies;

  const CurrencyWidget({super.key, this.onSelected, this.initialCurrency, required this.currencies, this.error, bool? visibleLabel, bool? showIcon})
      : visibleLabel = visibleLabel ?? true,
        showIcon = showIcon ?? true;

  @override
  State<CurrencyWidget> createState() => CurrencyWidgetState();
}

class CurrencyWidgetState extends State<CurrencyWidget> {
  late String currency;

  @override
  void initState() {
    super.initState();
    currency = widget.initialCurrency ?? 'USD';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.visibleLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose a currency',
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
            final result = await modalBottomSheet<String>(context, CurrencyModal(currencies: widget.currencies));
            if (result != null) {
              widget.onSelected!(result);
              setState(() {
                currency = result;
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
                Text(
                  currency,
                  style: const TextStyle(
                    color: Colors.indigo,
                  ),
                ),
                if (widget.showIcon)
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

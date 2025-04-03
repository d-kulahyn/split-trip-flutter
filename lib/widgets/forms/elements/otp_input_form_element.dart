import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPInput extends StatefulWidget {
  final int length;
  final void Function(String) onCompleted;

  const OTPInput({super.key, required this.length, required this.onCompleted});

  @override
  State<OTPInput> createState() => OTPInputState();
}

class OTPInputState extends State<OTPInput> with WidgetsBindingObserver {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  List<String> code = [];

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.length, (_) => TextEditingController());
    focusNodes = List.generate(widget.length, (_) => FocusNode());
    code = List.generate(widget.length, (_) => '');
    WidgetsBinding.instance.addObserver(this);

    paste();
  }

  Future<void> paste() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final pastedText = clipboardData?.text?.trim() ?? '';

    if (mounted && pastedText.length == widget.length && RegExp(r'^\d+$').hasMatch(pastedText)) {
      setState(() {
        for (int i = 0; i < widget.length; i++) {
          controllers[i].text = pastedText[i];
          code[i] = pastedText[i];
        }
        FocusScope.of(context).unfocus();
        widget.onCompleted(code.join());
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      paste();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    for (var controller in controllers) {
      controller.dispose();
    }

    for (var node in focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  void onChanged(String value, int index) {
    if (value.isNotEmpty) {
      code[index] = value;
      if (index < widget.length - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
        
        return;
      }

      FocusScope.of(context).unfocus();
      widget.onCompleted(code.join());
      
      return;
    }

    onBackspace(index);
  }

  void onBackspace(int index) async {
    if (index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 50,
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            onChanged: (value) => onChanged(value, index),
            onTap: () => controllers[index].selection = TextSelection.fromPosition(
              TextPosition(offset: controllers[index].text.length),
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
            ),
          ),
        );
      }),
    );
  }
}

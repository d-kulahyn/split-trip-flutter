import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_trip/widgets/arrow_back.dart';

import '../../providers/loader_provider.dart';
import '../theme_components/loader.dart';

class FormModal extends StatefulWidget {
  final Widget body;
  final Function? save;
  final String? title;

  const FormModal({super.key, required this.body, this.save, this.title});

  @override
  State<FormModal> createState() => FormModalState();
}

class FormModalState extends State<FormModal> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.95,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15),
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
                        Visibility(
                          visible: widget.save != null,
                          child: TextButton(
                            onPressed: () {
                              widget.save!();
                            },
                            child: const Text('Save'),
                          ),
                        )
                      ],
                    ),
                  ),
                  widget.body
                ],
              ),
            ),
          ),
          Consumer<LoaderProvider>(
            builder: (context, loader, child) => Visibility(
              visible: loader.show,
              child: Center(
                child: screenLoader(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

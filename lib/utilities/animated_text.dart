import 'package:flutter/cupertino.dart';

import '../constants/theme_constants.dart';

class AnimatedText extends StatelessWidget {
  final String? text;

  const AnimatedText({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: text?.isNotEmpty ?? false
          ? Align(
              key: ValueKey(text),
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: cTextFormFieldErrorMessageTop),
                child: Text(
                  text ?? '',
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  maxLines: null,
                  style: const TextStyle(color: cTextFormFieldErrorMessageColor),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

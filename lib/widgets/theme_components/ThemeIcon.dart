import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ThemeIconButton extends StatelessWidget {
  final String? iconPath;
  final Color? background;
  final double? size;
  final double? iconSize;
  final String? label;

  const ThemeIconButton({super.key, this.iconPath, this.background, this.label, this.size = 50, this.iconSize = 20});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: background ?? const Color.fromRGBO(255, 255, 255, 0.1),
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath!,
              width: iconSize,
              height: iconSize,
            ),
          ),
        ),
        Visibility(
          visible: label != null,
          child: Positioned(
            top: -10,
            right: -10,
            child: Container(
              padding: const EdgeInsets.all(5),
              constraints: const BoxConstraints(
                minWidth: 25,
                minHeight: 25
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromRGBO(251, 75, 75, 1),
              ),
              child: Center(
                child: Text(
                  label ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/theme_constants.dart';

class Button extends StatelessWidget {
  final String? iconPath;
  final Color? textColor;
  final String text;
  final Color? background;
  
  const Button({super.key, this.iconPath, this.textColor, this.background, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          color: background ?? mainColor,
          borderRadius: BorderRadius.circular(50)
      ),
      child: Center(
        child: Wrap(
          spacing: 4,
          children: [
            if (iconPath != null)
              SvgPicture.asset(
                iconPath!,
                width: 20,
                height: 20,
              ),
            Text(
              text,
              style: TextStyle(
                  color: textColor ?? const Color.fromRGBO(255, 255, 255, 1)
              ),
            ),
          ],
        ),
      ),
    );
  }
}

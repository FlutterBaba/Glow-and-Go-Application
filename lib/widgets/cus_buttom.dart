import 'package:flutter/cupertino.dart';
import 'package:glow_and_go/style/app_color.dart';

import '../style/text_style.dart';

class CusButtom extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color? color;

  final Color? textColor;
  const CusButtom({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color ?? AppColor().kdark1,
          // AppColor().kdark1,
        ),
        child: Center(
          child: Text(
            text,
            style: b1Bold.copyWith(
              color: textColor ?? AppColor().kdark3,
            ),
          ),
        ),
      ),
    );
  }
}

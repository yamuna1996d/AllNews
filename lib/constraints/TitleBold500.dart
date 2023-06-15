import 'package:flutter/material.dart';

class TitleBold500 extends StatelessWidget {
  final String title, fontFamily;
  final Color titleColor;
  final double fontSize;
  final int maxLines;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextOverflow? overflow;
  final TextDecoration? textDecoration;

  const TitleBold500({
    super.key,
    this.title = "",
    this.fontFamily = 'DMSans',
    this.titleColor = Colors.black,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.maxLines = 200,
    this.textAlign = TextAlign.left,
    this.overflow,
    this.textDecoration = TextDecoration.none,
  }); //11

  @override
  Widget build(BuildContext context) {
    return Text(title,
        maxLines: maxLines,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: fontWeight, fontSize: fontSize, color: titleColor),
        textAlign: textAlign);
  }
}

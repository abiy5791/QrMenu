import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double? fontsize;
  final FontWeight? fontWeight;
  final Color? textcolor;
final TextAlign? textAlign;

  const TextWidget(
      {super.key,
      required this.text,
      this.textAlign=TextAlign.start,
      this.fontsize = 16,
      this.fontWeight = FontWeight.normal,
      this.textcolor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontsize,
        fontWeight: fontWeight,
        color: textcolor,
      ),
    );
  }
}

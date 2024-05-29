import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final int color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

   TextWidget({required this.text, required this.color, required this.fontSize, required this.fontWeight, required this.textAlign});



  @override
  Widget build(BuildContext context) {
    int value;
    Color? otherColor;
    print(otherColor);
    return Text(
      text,
      overflow: TextOverflow.fade,
      textAlign: textAlign,
      style: GoogleFonts.getFont("Poppins",
        color: Color(color),
        fontSize: fontSize,
        fontWeight: fontWeight,),
    );
  }
}
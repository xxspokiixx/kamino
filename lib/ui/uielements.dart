
import 'package:flutter/material.dart';

class TitleText extends Text {

  TitleText(String data, {double fontSize, Color textColor}) : super(
    data,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: 'GlacialIndifference',
      fontSize: fontSize,
      color: textColor
    ),
    maxLines: 1
  );

}
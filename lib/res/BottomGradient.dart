import 'package:flutter/material.dart';

class BottomGradient extends StatelessWidget {
  final double offset;

  BottomGradient({this.offset: 0.98});

  BottomGradient.noOffset() : offset = 1.0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            end: FractionalOffset(0.0, 0.0),
            begin: FractionalOffset(0.0, offset),
            colors: <Color>[
              Colors.black,
              Color(0x002C2B33),
              Color(0x002C2B33)
            ],
          )),
    );
  }
}
import 'package:flutter/material.dart';

class BottomGradient extends StatelessWidget {
  // Positional offset.
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
            stops: [
              0.1,
              0.35,
              0.9
            ],
            colors: <Color>[
//              Color(0xFF313038),
//              Color(0x20313038),
//              Color(0x70000000)
              Color(0xFF000000),
              Color(0x20000000),
              Color(0x70000000)
            ],
          )),
    );
  }
}
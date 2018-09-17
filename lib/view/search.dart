import 'package:flutter/material.dart';
import 'package:kamino/main.dart';
import 'package:kamino/ui/uielements.dart';

class SearchView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleText("Search"),
        // MD2: make the color the same as the background.
        backgroundColor: backgroundColor,
        // Remove box-shadow
        elevation: 0.00
      ),
      body: Center(

      )
    );
  }

}
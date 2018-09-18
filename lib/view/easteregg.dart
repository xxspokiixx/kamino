import 'package:flutter/material.dart';

class EasterEggView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
          Positioned.fill(
            child: new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("images/easteregg/background.jpg"),
                  fit: BoxFit.cover
                )
              ),
              child: Image(image: new AssetImage("images/easteregg/socks.png"))
            )
        )
      ])
    );
  }

}
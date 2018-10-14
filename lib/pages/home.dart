import 'package:flutter/material.dart';
import 'package:kamino/main.dart';
import 'package:kamino/ui/uielements.dart';

class HomePage {
  build(BuildContext context) {
    return new SafeArea(
        child: new Container(
            padding: EdgeInsets.only(top: 5.0),
            color: backgroundColor,
            child: new ListView(children: [
              new Card(
                  color: const Color(0xFF404040),
                  child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.playlist_play),
                          title: TitleText('Continue Watching'),
                          subtitle: const Text(
                              "Start watching right where you left off..."
                          ),
                        )
                      ])),
              new Card(
                  color: const Color(0xFF404040),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.trending_up),
                        title: TitleText('Trending on ApolloTV'),
                        subtitle: const Text('What others are watching.'),
                      )
                    ],
                  )),

              /*
          new MaterialButton(
            onPressed: (){
              Navigator.push(
                  context,
                  FadeRoute(builder: (context) => CPlayer(
                    url: "http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_60fps_normal.mp4"
                  )),
              );
            },
            child: new Text("Debug Player"),
            color: Theme.of(context).primaryColor,
          )
          */
            ])));
  }
}

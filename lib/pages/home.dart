import 'package:flutter/material.dart';
import 'package:kamino/animation/transition.dart';
import 'package:kamino/ui/uielements.dart';

import 'package:cplayer/cplayer.dart';

class HomePage {

  build(BuildContext context){
    return new ListView(
        children: [
          new Card(
              child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: const Icon(Icons.playlist_play),
                      title: const TitleText('Continue Watching'),
                      subtitle: const Text("Start watching right where you left off..."),
                    )
                  ]
              )
          ),

          new Card(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    leading: const Icon(Icons.trending_up),
                    title: const TitleText('Trending on ApolloTV'),
                    subtitle: const Text('What others are watching.'),
                  )
                ],
              )
          ),

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
        ]
    );
  }

}
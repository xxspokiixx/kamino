import 'package:flutter/material.dart';
import 'package:kamino/ui/uielements.dart';

class HomePage {

  build(){
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
          )
        ]
    );
  }

}
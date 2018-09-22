import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kamino/animation/transition.dart';
import 'package:kamino/main.dart';
import 'package:kamino/ui/uielements.dart';
import 'package:kamino/view/easteregg.dart';
import 'package:package_info/package_info.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  PackageInfo _packageInfo = new PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown'
  );

  @override
  void initState(){
    super.initState();
    _fetchPackageInfo();
  }

  Future<Null> _fetchPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  int versionTapCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TitleText("Settings"),
            // MD2: make the color the same as the background.
            backgroundColor: backgroundColor,
            // Remove box-shadow
            elevation: 0.00
        ),
        body: new Builder(
          builder: (BuildContext context){
            return new ListView(
              children: <Widget>[
                ListTile(
                    title: TitleText("Apollo Version"),
                    subtitle: Text("v${_packageInfo.version}_build-${_packageInfo.buildNumber}"),
                    onTap: () {
                      versionTapCount += 1;
                      if(versionTapCount >= 10){

                        Navigator.push(
                            context,
                            SlideLeftRoute(builder: (context) => EasterEggView())
                        );

                        versionTapCount = 0;
                      }
                    }
                )
              ]
            );
          }
        )
    );
  }

}
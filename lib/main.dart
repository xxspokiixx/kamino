import 'dart:math';
import 'dart:async';
import 'view/search.dart';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

const primaryColor = Color(0xFF4E5D72);
const appName = "ApolloTV";

void main(){
  runApp(new MaterialApp(
    title: appName,
    home: KaminoApp(),
    theme: new ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      accentColor: Colors.lightBlue[600],
      splashColor: Colors.white,
      highlightColor: Colors.white
    ),
  ));
}

class KaminoApp extends StatefulWidget {
  @override
  HomeAppState createState() => new HomeAppState();
}

class HomeAppState extends State<KaminoApp> {

  PackageInfo _packageInfo = new PackageInfo(
    appName: appName,
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text(appName)
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: null,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/header.png'),
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.bottomCenter
                ),
                color: const Color(0xFF4E5D72)
              )
            ),
            ListTile(
              leading: const Icon(Icons.gavel),
              title: Text('Disclaimer')
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: Text('Donate')
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('Settings')
            )
          ],
        )
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search, size: 32.0),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 12.0,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchView())
            );
          }
      ),


      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
          //TODO: Implement button code
            IconButton(
              onPressed: () => print("hello"),
              icon: Icon(Icons.home),
              color: Colors.grey.shade400),
            IconButton(
              onPressed: null,
              icon: Icon(Icons.movie),
              color: Colors.grey.shade400),
            Padding(
              padding: const EdgeInsets.only(left: 65.0),
              child: IconButton(
                onPressed: null,
                icon: Icon(Icons.live_tv),
                color: Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: null,
              icon: Icon(Icons.favorite),
              color: Colors.grey.shade400,
            ),
          ],
        ),
        elevation: 12.0,
      ),


    );
  }
}

// Import flutter libraries
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:kamino/ui/uielements.dart';

// Import custom libraries / utils
import 'animation/transition.dart';

// Import views
import 'view/search.dart';
import 'view/settings.dart';

// Import pages
import 'pages/home.dart';

const primaryColor = const Color(0xFF4E5D72);
const secondaryColor = const Color(0xFF303A47);
const backgroundColor = const Color(0xFF303030);
const appName = "ApolloTV";

void main(){

  // MD2: Remove status bar translucency.
  changeStatusColor(Color color) async {
    try {
      await FlutterStatusbarcolor.setStatusBarColor(color);
    } on PlatformException catch (e) {
      print(e);
    }
  }
  changeStatusColor(const Color(0x00000000));

  runApp(new MaterialApp(
    title: appName,
    home: KaminoApp(),
    theme: new ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      accentColor: secondaryColor,
      splashColor: Colors.white,
      highlightColor: Colors.white,
      backgroundColor: backgroundColor
    ),

    // Remove debug banner - because it's annoying.
    debugShowCheckedModeBanner: false,
  ));
}

class KaminoApp extends StatefulWidget {
  @override
  HomeAppState createState() => new HomeAppState();
}

class HomeAppState extends State<KaminoApp> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: const TitleText(appName),
        // MD2: make the color the same as the background.
        backgroundColor: backgroundColor,
        // Remove box-shadow
        elevation: 0.00
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
              leading: const Icon(Icons.library_books),
              title: Text("News")
            ),
            Divider(),
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
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();

                Navigator.push(
                    context,
                    SlideLeftRoute(builder: (context) => SettingsView())
                );
              }
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
            IconButton(
              onPressed: () {
                // TODO: button code
              },
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


      // Body content
      body: HomePage().build(context)
    );
  }
}

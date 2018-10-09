import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SeasonOverView extends StatefulWidget {
  final List inputList;
  SeasonOverView({Key key, @required this.inputList}) : super(key: key);

  @override
  _SeasonOverViewState createState() => new _SeasonOverViewState();
}

class SeasonModel {
  final int seasonNumber, id;
  final List episodes;
  final String air_date;

  SeasonModel(this.seasonNumber, this.id, this.episodes, this.air_date);

  SeasonModel.fromJson(Map json):
        seasonNumber = json["season_number"], air_date = json["air_date"],
        id = json["id"], episodes = json["episodes"];
}

class _SeasonOverViewState extends State<SeasonOverView> {

  List<SeasonModel> results;
  List<SeasonModel> temp;

  Future<List<SeasonModel>> _getSeasonData() async {
    List<SeasonModel> _data = [];
    Map _json;

    String url = "https://api.themoviedb.org/3/tv/${widget.inputList[0]}/season/"
        "${widget.inputList[1]}?"
        "api_key=b52e4d8c6e0b014ced7de2f7ea6f4284&language=en-US";

    http.Response res  = await http.get(url);

    _json = jsonDecode(res.body);

    SeasonModel _dataMine = new SeasonModel(_json["season_number"],
        _json["id"], _json["episodes"], _json["air_date"]);

    _data.add(_dataMine);

    return _data;
  }

  List<Widget> _createTabs(AsyncSnapshot snapshot) {

    List<Widget> _tabsMade = [];
    String seasonNum = snapshot.data[0].seasonNumber.toString();

    for(int i = 0; i < snapshot.data[0].episodes.length; i++){

      String episodeNum = (snapshot.data[0].episodes[i]["episode_number"]).toString();
      _tabsMade.add( Container(
              child: Tab(text: "$seasonNum x $episodeNum"), width: 39.0,));
    }

    return  _tabsMade;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: _getSeasonData(),
        builder: (BuildContext context, AsyncSnapshot snapshot){

          print("............ ${snapshot.data}");

          if (snapshot.hasData) {

            if (snapshot.data[0].episodes != null) {
              return DefaultTabController(
                length: snapshot.data[0].episodes.length,
                child: Scaffold(
                  appBar: new AppBar(
                    actions: <Widget>[
                      Checkbox(value: false, onChanged: null),
                      IconButton(icon: Icon(Icons.sort), onPressed: null),
                    ],
                    elevation: 12.0,
                    bottom: TabBar(
                      isScrollable: true,
                      tabs: _createTabs(snapshot),
                    ),
                  ),
                  body: TabBarView(
                    children: _tabBodyGenerator(snapshot),
                  ),
                  floatingActionButton: new FloatingActionButton(
                    onPressed: () =>  print("The id is"), backgroundColor: Colors.red,
                    elevation: 13.0,
                    child: Icon(
                        Icons.play_arrow, color: Colors.white, size: 46.0),
                  ),
                ),
              );

            }else {
              return Scaffold(
                appBar: new AppBar(),
                body: Center(
                  child: Text("No Episodes Found, Try Again Later"),),
              );
            }


          } else if (snapshot.hasError) {
            return new Center(child:Text("${snapshot.error}"));

          }

          return Center(
              child: new CircularProgressIndicator(
                backgroundColor: Colors.deepPurpleAccent,));
        }
    );
  }


  List<Widget> _tabBodyGenerator(AsyncSnapshot snapshot) {
    List<Widget> _tabBodies = [];

    for(int i = 0; i < snapshot.data[0].episodes.length; i++){

      _tabBodies.add(
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(left: 12.0, top:  15.0),
                  child: snapshot.data[0].episodes[i]["name"] == null ? Container() :
                  Text(snapshot.data[0].episodes[i]["name"], textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold,),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 12.0, top:  4.0),
                  child:snapshot.data[0].episodes[i]["air_date"] == null ? Container() :
                  Text(snapshot.data[0].episodes[i]["air_date"],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15.0)
                    ,),
                ),


                Padding(
                  padding: EdgeInsets.only(left: 12.0, top:  8.0, right: 12.0),
                  child:episodeImage(snapshot, i),
                ),

                Padding(
                  padding: EdgeInsets.only(
                      left: 12.0, top:  14.0, right: 12.0, bottom: 14.0),
                  child:Divider(height: 4.0,),
                ),

                Padding(
                  padding: EdgeInsets.only(
                      left: 12.0, right: 12.0, bottom: 19.0),
                  child: snapshot.data[0].episodes[i]["overview"] == null ?
                  Container() :
                  Text(
                    snapshot.data[0].episodes[i]["overview"],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: "Roboto", fontSize: 15.0, height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

      );
    }

    return _tabBodies;
  }

  Widget episodeImage(AsyncSnapshot snapshot ,int index){

    if (snapshot.data[0].episodes[index]["still_path"] != null){

      return Center(
        child: FadeInImage.assetNetwork(
          placeholder: "assets/images/no_image_detail.jpg",
          image: "http://image.tmdb.org/t/p/w500"+
              snapshot.data[0].episodes[index]["still_path"],
          height: 220.0,
          width: 700.0,
          fit: BoxFit.fill,
        ),
      );

    } else{

      return Center(
        child: Image.asset(
            "assets/images/no_image_detail.jpg",
          height: 220.0,
          width: 700.0,
          fit: BoxFit.fill,
        ),
      );
    }
  }

}
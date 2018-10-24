import 'package:intl/intl.dart';
import 'package:kamino/api.dart' as api;

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kamino/ui/uielements.dart';


class SeasonOverview extends StatefulWidget {
  final List inputList;
  SeasonOverview({Key key, @required this.inputList}) : super(key: key);

  @override
  _SeasonOverviewState createState() => new _SeasonOverviewState();
}

class SeasonModel {
  final int seasonNumber, id;
  final List episodes;
  final String airDate;

  SeasonModel(this.seasonNumber, this.id, this.episodes, this.airDate);

  SeasonModel.fromJson(Map json):
        seasonNumber = json["season_number"], airDate = json["air_date"],
        id = json["id"], episodes = json["episodes"];
}

class _SeasonOverviewState extends State<SeasonOverview> {

  List<SeasonModel> results;
  List<SeasonModel> temp;

  Future<List<SeasonModel>> _getSeasonData() async {
    List<SeasonModel> _data = [];
    Map _json;

    String url = "${api.tvdb_root_url}/tv/${widget.inputList[0]}/season/"
        "${widget.inputList[1]}${api.tvdb_default_arguments}";

    http.Response res  = await http.get(url);

    _json = jsonDecode(res.body);

    SeasonModel _dataMine = new SeasonModel(_json["season_number"],
        _json["id"], _json["episodes"], _json["air_ate"]);

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
                  backgroundColor: Colors.black,
                  appBar: new AppBar(
                    actions: <Widget>[
                      Checkbox(value: false, onChanged: null),
                      IconButton(icon: Icon(Icons.sort), onPressed: null),
                    ],
                    elevation: 12.0,
                    bottom: TabBar(
                      isScrollable: true,
                      tabs: _createTabs(snapshot),
                      indicatorColor: Colors.white,
                    ),
                  ),
                  body: TabBarView(
                    children: _tabBodyGenerator(snapshot),
                  ),
                  floatingActionButton: new FloatingActionButton.extended(
                    onPressed: () {
                      // TODO: Play TV Show episode
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                                title: Text("We're working on it..."),
                                content: Text("You know, I think someone said this was an important feature.")
                            );
                          }
                      );
                    },
                    icon: Icon(Icons.play_arrow),
                    label: Text(
                      "Play Episode",
                      style: TextStyle(
                          letterSpacing: 0.0,
                          fontFamily: 'GlacialIndifference',
                          fontSize: 16.0
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              );

            }else {
              return Scaffold(
                appBar: new AppBar(),
                body: Center(
                  child: Text("No episodes found."),),
              );
            }


          } else if (snapshot.hasError) {
            return new Center(child:Text("${snapshot.error}"));

          }

          return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor
              ),
            )
          );
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
                  TitleText(snapshot.data[0].episodes[i]["name"], fontSize: 32.0)
                ),

                Padding(
                  padding: EdgeInsets.only(left: 12.0, top:  4.0),
                  child:snapshot.data[0].episodes[i]["air_date"] == null ? Container() :
                  Text(
                    new DateFormat.yMMMMd("en_US").format(
                      DateTime.parse(snapshot.data[0].episodes[i]["air_date"])
                    ),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey
                    )
                    ,),
                ),


                Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 24.0, right: 12.0),
                  child:episodeImage(snapshot, i),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    top: 12.0,
                      left: 12.0, right: 12.0, bottom: 19.0),
                  child: snapshot.data[0].episodes[i]["overview"] == null ?
                  Container() :
                  Text(
                    snapshot.data[0].episodes[i]["overview"],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: "Roboto", fontSize: 15.0, height: 1.3,
                      color: Colors.grey
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
          fit: BoxFit.cover,
        ),
      );

    } else{

      return Center(
        child: Image.asset(
            "assets/images/no_image_detail.jpg",
          height: 220.0,
          width: 700.0,
          fit: BoxFit.cover,
        ),
      );
    }
  }

}
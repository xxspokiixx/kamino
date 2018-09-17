import 'package:flutter/material.dart';
import 'package:kamino/main.dart';
import 'package:kamino/ui/uielements.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => new _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  TextEditingController _searchField = new TextEditingController();
  GlobalKey<ScaffoldState> _key;
  var _screenBody;
  List<ResultsModel> searchResults = [];
  int searchState = 0;

  Future<List<ResultsModel>> getResults() async{

    if (_searchField.text.isNotEmpty != null) {
      searchResults.clear();
      var data = await http.get(
          "http://api.tvmaze.com/search/shows?q=${_searchField.text}");
      var jsonData = jsonDecode(data.body);


      print(jsonData[0]["show"]["image"]["original"].toString());

      for (var u in jsonData) {
        ResultsModel result = ResultsModel(u["show"]["image"]["original"].toString(),
            u["show"]["name"].toString(),u["show"]["externals"]["imdb"].toString(),
            u["show"]["externals"]["thetvdb"].toString());
        searchResults.add(result);
        //print(u["show"]["name"]);
      }


      //print("I found : " + searchResults.length.toString());
    }
  }

  _callAsync(){
    //print("Testing");
    getResults();
    print(searchResults.length);

    //if there is data change the body
    if (searchResults.isNotEmpty == true){
      //generate gridview
      setState(() {
       _screenBody = Container(
           child: GridView.builder(
               gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 3),
               itemBuilder: (BuildContext context, int index){
                 return new GestureDetector(
                   onTap: null,
                   onLongPress: null,
                   child: _resultsCard(context, index),
                 );
               }));
      });

    }else{
      setState(() {
        _screenBody = Center(child: Text("No Matches"),);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new TextField(
          autofocus: true,
          style: new TextStyle(
            fontSize: 18.0,
          ),
          onSubmitted: _callAsync(),
          controller: _searchField,
          decoration: InputDecoration(
            hintText: "Enter TV Show or Movie..."
          ),
        ),
        // MD2: make the color the same as the background.
        backgroundColor: backgroundColor,
        // Remove box-shadow
        elevation: 0.00
      ),
      body: _screenBody,
    );
  }

  Widget _resultsCard(BuildContext context, int index){
    return new Card(
      elevation: 5.0,
      child: new Column(
        children: <Widget>[
          Image.network(searchResults[index].getImage)
        ],
      ),
    );
  }

}

class ResultsModel{
  final String image;
  final String title;
  final String imdb;
  final String thetvdb;

  ResultsModel(this.image,this.title,this.imdb,this.thetvdb);

  String get getImage => this.image;
}
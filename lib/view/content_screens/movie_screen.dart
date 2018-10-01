import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class _movieScreenModel {
  final String posterPath, backdropPath, title;
  final String release_date, homepage, imdb_id;
  final List genre;
  final String runtime, overview;
  final int id;

  _movieScreenModel(this.id, this.posterPath, this.backdropPath,
      this.release_date, this.overview, this.runtime,
      this.title, this.homepage, this.imdb_id, this.genre);

}


class MovieOverview extends StatelessWidget {
  final int id;
  MovieOverview(this.id);

  Future<List<_movieScreenModel>> _getOverview() async {
    List<_movieScreenModel> _data;
    Map json;

    String url = "https://api.themoviedb.org/3/movie/$id?"
        "api_key=b52e4d8c6e0b014ced7de2f7ea6f4284&language=en-US";

    var res = await http.get(url);
    json = jsonDecode(res.body);

    List _genres = [];

    int counter = json["genres"].length;
    for (int x = 0; x < counter; x++){
      _genres.add(json["genres"][x]);
    }

    var _dataMine = new _movieScreenModel(
        json["belongs_to_collection"]["id"],
        json["belongs_to_collection"]["poster_path"],
        json["belongs_to_collection"]["backdrop_path"],
        json["release_date"], json["overview"], json["runtime"],
        json["title"], json["homepage"], json["imdb_id"], _genres);

    _data.add(_dataMine);

    return _data;
  }

  Widget _movieHeader(BuildContext context, AsyncSnapshot snapshot) {
    return Stack(
      children: <Widget>[
        //TODO: URL HERE
        Image.network("http://image.tmdb.org/t/p/w500" +
            snapshot.data[0].backdropPath,
          fit: BoxFit.fill,
          height: 220.0,
        ),
        _headerOverlay(context, snapshot),
      ],
    );
  }

  Widget _genreChips(BuildContext context, AsyncSnapshot snapshot) {
    List<Widget> _data;

    for (int x = 0; 0 < snapshot.data[0].genre.length; x++){
      _data.add( new Chip(label: Text(snapshot.data[0].genre[x])));
    }

    return new Row(children: _data);
  }

  Widget _headerOverlay(BuildContext context, AsyncSnapshot snapshot) {
    return Row(
      children: <Widget>[
        Card(
          child: Center(
            child: Image.network(null,
              fit: BoxFit.fill,
              height: 752.0,
              width: 500.0,
            ),
          ),
          elevation: 8.0,
        ),
        Column(
          children: <Widget>[
            //INSERT FILM TITLE HERE
            Text(snapshot.data[0].title, style: TextStyle(
                fontSize: 24.0, fontWeight: FontWeight.bold),
            ),

            //Chips for release date and duration
            _genreChips(context, snapshot),

            Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.link), onPressed: null),
                IconButton(icon: Icon(Icons.favorite), onPressed: null),
              ],
            )
          ],
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: _getOverview(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    _movieHeader(context, snapshot),
                    //TODO: Tabs for the rest here
                    //Info (add actors here), reviews, similar
                    Card(
                      child: Column(
                        children: <Widget>[
                          Text("Overview"),
                          Divider(),
                          Text(snapshot.data[0].overview),
                        ],
                      ),
                    ),
                    Card( child: Column(
                      children: <Widget>[

                      ],
                    ),),

                    Card(child: Column(
                      children: <Widget>[
                        Text(snapshot.data[0].release_date),
                      ],
                    ),),

                  ],
                );
              } else if (snapshot.hasError) {
                return new Center(child:Text("${snapshot.error}"));
              }

              return new CircularProgressIndicator();
            }
        ),
      ),
    );
  }

}
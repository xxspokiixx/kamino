import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_rating/flutter_rating.dart';

class _movieScreenModel {
  final String posterPath, backdropPath, title;
  final String release_date, homepage, imdb_id;
  final List genre, reviews, recommendations;
  final String overview;
  final int runtime, id;
  final double rating;
  final int vote_count;

  _movieScreenModel(this.id, this.posterPath, this.backdropPath,
      this.release_date, this.overview, this.runtime,
      this.title, this.homepage, this.imdb_id, this.genre, this.vote_count,
      this.rating, this.reviews, this.recommendations);

}

class MovieOverview extends StatelessWidget {
  final int id;
  MovieOverview(this.id);

  Future<List<_movieScreenModel>> _getOverview() async {

    print("I am using....... $id");

    List<_movieScreenModel> _data = [];
    Map json, _json, _recomJson;

    String url = "https://api.themoviedb.org/3/movie/$id?"
        "api_key=b52e4d8c6e0b014ced7de2f7ea6f4284&language=en-US";

    String _reviewsUrl = "https://api.themoviedb.org/3/movie/$id/reviews?"
        "api_key=b52e4d8c6e0b014ced7de2f7ea6f4284&language=en-US&page=1";

    String _recommendUrl = "https://api.themoviedb.org/3/movie/$id/similar?"
        "api_key=b52e4d8c6e0b014ced7de2f7ea6f4284&language=en-US&page=1";

    var res = await http.get(url);
    json = jsonDecode(res.body);

    List _genres = [];

    int counter = json["genres"].length;
    for (int x = 0; x < counter; x++){
      _genres.add(json["genres"][x]);
    }

    var _res = await http.get(_reviewsUrl);
    _json = jsonDecode(_res.body);

    var recomRes = await http.get(_recommendUrl);
    _recomJson = jsonDecode(recomRes.body);

    _movieScreenModel _dataMine = new _movieScreenModel(
        id,
        json["poster_path"],
        json["backdrop_path"],
        json["release_date"], json["overview"], json["runtime"],
        json["title"], json["homepage"], json["imdb_id"], _genres,
        json["vote_count"] != null ? json["vote_count"]: 0,
        json["vote_average"] != null ? json["vote_average"]: 0,
        _json["results"], _recomJson["results"]);

    _data.add(_dataMine);

    return _data;
  }

  Widget _backDropImage(AsyncSnapshot snapshot) {
    return Container(
      child: snapshot.data[0].backdropPath != null ?
      Image.network("http://image.tmdb.org/t/p/w500" +
          snapshot.data[0].backdropPath,
        fit: BoxFit.cover,
        height: 240.0,
      ) : Image.asset("assets/images/no_image_detail.jpg",
        fit: BoxFit.cover,
        height: 240.0,
      ),
    );
  }


  Widget _infoCard(BuildContext context, AsyncSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: Card(
        elevation: 7.0,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 25.0, right: 47.0),
              child: Text(snapshot.data[0].title != null ? snapshot.data[0].title :
              "Title Unavailable", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ),

            //Overview Text
            Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: ExpansionTile(
                title: Text("Storyline", style: TextStyle(
                    fontSize: 17.0, fontFamily: "Roboto"),
                ),
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 17.0, right: 20.0, bottom: 17.0),
                      child: Text(snapshot.data[0].overview != null ? snapshot.data[0].overview :
                      "Storyline Unavailable",
                        style: TextStyle(fontSize: 15.0, fontFamily: "Roboto"),
                        maxLines: 20, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Genre ListView
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 13.0),
              child: SizedBox(
                height: 40.0,
                child: _genreList(snapshot),
              ),
            ),

            //Rating stars
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 17.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(snapshot.data[0].rating.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white, fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _starRating(snapshot),
                    ),
                    Text("(${snapshot.data[0].vote_count})",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey, fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Runtime and year info
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 15.0),
              child: _runtimeAndYear(snapshot),
            )


          ],
        ),
      ),
    );
  }

  Widget _genreList(AsyncSnapshot snapshot){

    return Container(
      child: ListView.builder(
        itemCount: snapshot.data[0].genre.length == null ?
        0 : snapshot.data[0].genre.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index){
          return Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: new Chip(
                label: Text(
                  snapshot.data[0].genre[index]["name"],
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
                backgroundColor: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _starRating(AsyncSnapshot snapshot) {
    //double rating = (snapshot.data[0].rating).toDouble();
    print(snapshot.data[0].rating);


    return new StarRating(
      rating: 3.2,
      color: Colors.yellow,
      borderColor: Colors.transparent,
      size: 26.0,
      starCount: 5,
    );
  }

  Widget _runtimeAndYear(AsyncSnapshot snapshot) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Runtime: ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: new Chip(label: Text(snapshot.data[0].runtime == null ?
              "Unavialable" : snapshot.data[0].runtime.toString()+" minutes",
                style: TextStyle(color: Colors.black, fontSize: 17.0,
                ),
              ),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),

        //Release Year
        Row(
          children: <Widget>[
            Text("Release Date: ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Chip(label: Text(snapshot.data[0].release_date == null ?
              "Unavialable" : snapshot.data[0].release_date.toString(),
                style: TextStyle(color: Colors.black, fontSize: 17.0,
                ),
              ),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),


      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FutureBuilder(
                  future: _getOverview(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if (snapshot.hasData) {

                      return Container(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                _backDropImage(snapshot),

                                Padding(
                                  padding: const EdgeInsets.only(top: 170.0, bottom: 30.0, left: 16.0),
                                  child: _infoCard(context, snapshot),
                                ),
                              ],
                            ),

                            _similarMovies(context, snapshot),


                          ],
                        ),
                      );

                    } else if (snapshot.hasError) {
                      return new Center(child:Text("${snapshot.error}"));
                    }

                    return Center(child: new CircularProgressIndicator());
                  }
              ),
            ],
          )
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _playButtonActivity(),
        child: Icon(
          Icons.play_arrow, color: Colors.white,
          size: 36.0,
        ),
        elevation: 8.0,
        backgroundColor: Colors.red,
      ),
    );
  }

  _playButtonActivity(){

  }

  Widget _similarMovies(BuildContext context, AsyncSnapshot snapshot){
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 39.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 173.0),
                  child: Text("Similar Movies",
                    style: TextStyle(
                        fontSize: 21.0, fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"), maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),

        //Search Results
        Padding(
          padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
          child: SizedBox (
            child: _genRecomCards(context, snapshot),
            height: 208.0,
          ),
        ),

      ],
    );
  }

  Widget _genRecomCards(BuildContext context, AsyncSnapshot snapshot){

    if (snapshot.data[0].recommendations != null){

      return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data[0].recommendations.length,
          itemBuilder: (BuildContext context, int index){

            return Padding(
              padding: index == 0 ? const EdgeInsets.only(left: 18.0) :
              const EdgeInsets.only(left: 0.0),
              child: InkWell(
                splashColor: Colors.white,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Card(
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(5.0),
                            child: Container(
                              child: snapshot.data[0].recommendations[index]["poster_path"] != null ?
                              Image.network("http://image.tmdb.org/t/p/w500" +
                                  snapshot.data[0].recommendations[index]["poster_path"],
                                fit: BoxFit.fill,
                                height: 185.0,
                              ) : Image.asset("assets/images/no_image_detail.jpg",
                                fit: BoxFit.fill,
                                width: 130.0,
                                height: 185.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      );

    }else {
      return Container();
    }
  }

}


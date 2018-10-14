import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:http/http.dart' as http;
import 'package:eventsource/eventsource.dart';
import 'package:cplayer/cplayer.dart';
import 'package:kamino/animation/transition.dart';

import '../../api.dart';

/*
    TODO: Move 'Movie' / 'TV Show' label to top of card.
 */

class _movieScreenModel {
  final String posterPath, backdropPath, title;
  final String release_date, homepage, imdb_id;
  final List genre, reviews, recommendations;
  final String overview;
  final int runtime, id;
  final double rating;
  final int vote_count;

  _movieScreenModel(
      this.id,
      this.posterPath,
      this.backdropPath,
      this.release_date,
      this.overview,
      this.runtime,
      this.title,
      this.homepage,
      this.imdb_id,
      this.genre,
      this.vote_count,
      this.rating,
      this.reviews,
      this.recommendations);
}

class MovieOverview extends StatefulWidget {
  final int id;
  MovieOverview({Key key, @required this.id}) : super(key: key);

  @override
  _movieOverviewState createState() => new _movieOverviewState();
}

class _movieOverviewState extends State<MovieOverview> {
  Future<List<_movieScreenModel>> _getOverview() async {
    List<_movieScreenModel> _data = [];
    Map json, _json, _recomJson;

    String url =
        "${tvdb_root_url}/movie/${widget.id.toString() + tvdb_default_arguments}";

    String _reviewsUrl =
        "${tvdb_root_url}/movie/${widget.id}/reviews${tvdb_default_arguments}&page=1";

    String _recommendUrl =
        "${tvdb_root_url}/movie/${widget.id}/similar${tvdb_default_arguments}&page=1";

    var res = await http.get(url);
    json = jsonDecode(res.body);

    List _genres = [];

    int counter = json["genres"].length;
    for (int x = 0; x < counter; x++) {
      _genres.add(json["genres"][x]);
    }

    var _res = await http.get(_reviewsUrl);
    _json = jsonDecode(_res.body);

    var recomRes = await http.get(_recommendUrl);
    _recomJson = jsonDecode(recomRes.body);

    _movieScreenModel _dataMine = new _movieScreenModel(
        json["id"],
        json["poster_path"],
        json["backdrop_path"],
        json["release_date"],
        json["overview"],
        json["runtime"],
        json["title"],
        json["homepage"],
        json["imdb_id"],
        _genres,
        json["vote_count"] != null ? json["vote_count"] : 0,
        json["vote_average"] != null ? json["vote_average"] : 0,
        _json["results"],
        _recomJson["results"]);

    _data.add(_dataMine);

    return _data;
  }

  Widget _backDropImage(AsyncSnapshot snapshot, double width) {
    return Container(
      child: snapshot.data[0].backdropPath != null
          ? Image.network(
              "http://image.tmdb.org/t/p/w500" + snapshot.data[0].backdropPath,
              fit: BoxFit.cover,
              height: 180.0,
              width: width,
            )
          : Image.asset(
              "assets/images/no_image_detail.jpg",
              fit: BoxFit.cover,
              height: 180.0,
              width: width,
            ),
    );
  }

  Widget _storyline(AsyncSnapshot snapshot) {
    //Overview Text
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: ExpansionTile(
        title: Text(
          "Storyline",
          style: TextStyle(fontSize: 17.0, fontFamily: "Roboto"),
        ),
        children: <Widget>[
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 17.0, right: 20.0, bottom: 17.0),
              child: Text(
                snapshot.data[0].overview != null
                    ? snapshot.data[0].overview
                    : "Storyline Unavailable",
                style: TextStyle(fontSize: 15.0, fontFamily: "Roboto"),
                maxLines: 20,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genreList(AsyncSnapshot snapshot) {
    return Container(
      child: ListView.builder(
        itemCount: snapshot.data[0].genre.length == null
            ? 0
            : snapshot.data[0].genre.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Padding(
              padding: index != 0
                  ? EdgeInsets.only(left: 7.0, right: 2.0)
                  : EdgeInsets.only(left: 21.0, right: 2.0),
              child: new Chip(
                label: Text(
                  snapshot.data[0].genre[index]["name"],
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
                backgroundColor: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _starRating(AsyncSnapshot snapshot) {
    double rating = (snapshot.data[0].rating).toDouble();

    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 7.0),
          child: Text(
            snapshot.data[0].rating.toString() == null
                ? " "
                : snapshot.data[0].rating.toString(),
            style: TextStyle(
                color: Colors.redAccent,
                fontSize: 21.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new StarRating(
            rating: rating / 2,
            color: Colors.redAccent,
            borderColor: Theme.of(context).primaryColor,
            size: 26.0,
            starCount: 5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0, left: 12.0),
          child: Text(
            snapshot.data[0].vote_count.toString() == null
                ? " "
                : "(" + snapshot.data[0].vote_count.toString() + ")",
            style: TextStyle(
                color: Colors.redAccent,
                fontSize: 19.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder(
          future: _getOverview(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      actions: <Widget>[
                        //IconButton(icon: Icon(Icons.share, color: Colors.white,), onPressed: null),
                        IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                            onPressed: null),
                      ],
                      expandedHeight: 180.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Padding(
                            padding: const EdgeInsets.only(right: 0.0),
                            child: Text(
                                snapshot.data[0].title != null
                                    ? snapshot.data[0].title
                                    : "Title Unavailable",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.ltr),
                          ),
                          background: _backDropImage(snapshot, width)),
                    ),
                  ];
                },
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: width,
                          height: 40.0,
                          child: _genreList(snapshot),
                        ),
                      ),

                      //Ratings
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 22.0, bottom: 15.0),
                        child: _starRating(snapshot),
                      ),

                      //Details Card
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 18.0, right: 18.0, bottom: 10.0),
                        child: Card(
                          child: ExpansionTile(
                            title: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0,
                                  right: 10.0,
                                  left: 0.0,
                                  bottom: 10.0),
                              child: Text("Details",
                                  style: TextStyle(
                                      fontSize: 17.0, fontFamily: "Roboto")),
                            ),
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 150.0, bottom: 15.0),
                                    child: Text(
                                        snapshot.data[0].release_date == null
                                            ? "  "
                                            : "Release Year: " +
                                                snapshot.data[0].release_date
                                                    .toString()
                                                    .substring(0, 4),
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontFamily: "Roboto")),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 199.0, bottom: 15.0),
                                    child: Text(
                                        snapshot.data[0].runtime == null
                                            ? "  "
                                            : snapshot.data[0].runtime
                                                    .toString() +
                                                " minutes",
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontFamily: "Roboto")),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                        child: Card(
                          child: _storyline(snapshot),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
                        child: SizedBox(
                            height: 266.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: _similarMovies(context, snapshot),
                            )),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return new Center(child: Text("${snapshot.error}"));
            }

            return Center(
                child: new CircularProgressIndicator(
              backgroundColor: Colors.white,
            ));
          }),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          // Get claws token.
          String token = await getClawsToken();

          // Make HTTP request
          String title =
              (await _getOverview())[0].title.replaceAll("/ /g", "+");

          String source =
              claws_instance + "api/search/movies?title=$title&token=$token";
          EventSource streamingURLEventSource =
              await EventSource.connect(source);

          var hasFoundResult = false;

          streamingURLEventSource.listen((Event event) {
            if (hasFoundResult) {
              return;
            }

            if (event.event == "results") {
              var resultData = jsonDecode(event.data);
              if (resultData["m3u8File"] != null) {
                // TODO: handle m3u8 links
              } else {
                var videoSourceURL = resultData["videoSourceUrl"];
                print(videoSourceURL);
                Navigator.push(
                    context,
                    FadeRoute(
                        builder: (context) =>
                            ApolloTVPlayer(url: videoSourceURL)));
                hasFoundResult = true;
              }
            }
          });
        },
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 13.0,
        child: Icon(Icons.play_arrow, color: Colors.white, size: 46.0),
      ),
    );
  }

  Widget _similarMovies(BuildContext context, AsyncSnapshot snapshot) {
    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 174.0),
                child: Text(
                  "Similar Movies",
                  style: TextStyle(fontSize: 17.0, fontFamily: "Roboto"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        //Search Results
        Padding(
          padding: const EdgeInsets.only(top: 18.0, bottom: 0.0),
          child: SizedBox(
            child: _genRecomCards(context, snapshot),
            height: 208.0,
          ),
        ),
      ],
    );
  }

  Widget _genRecomCards(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data[0].recommendations != null) {
      return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data[0].recommendations.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: index == 0
                  ? const EdgeInsets.only(left: 18.0)
                  : const EdgeInsets.only(left: 0.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MovieOverview(
                              id: snapshot.data[0].recommendations[index]
                                  ["id"])));
                },
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
                              child: snapshot.data[0].recommendations[index]
                                          ["poster_path"] !=
                                      null
                                  ? Image.network(
                                      "http://image.tmdb.org/t/p/w500" +
                                          snapshot.data[0]
                                                  .recommendations[index]
                                              ["poster_path"],
                                      fit: BoxFit.fill,
                                      height: 185.0,
                                    )
                                  : Image.asset(
                                      "assets/images/no_image_detail.jpg",
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
          });
    } else {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Center(
                  child: Icon(
                    Icons.movie,
                    size: 80.0,
                    color: Colors.grey,
                  ),
                ),
                Center(
                  child: Text(
                    "No Recommedations Found",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

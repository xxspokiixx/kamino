import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:kamino/BottomGradient.dart';

const ThemeColor = Colors.deepPurple;
const primaryColor = ThemeColor;
const backgroundColor = Colors.black;
const highlightColor = Colors.white;
const appName = "ApolloTV";

class TVOverviewModel {
  final List created_by, genres, seasons, networks;
  final int vote_count;
  final double popularity, vote_average;
  final String status, backdrop_path, name, overview;
  final String poster_path, homepage, first_air_date;
  final int id, runtime;

  TVOverviewModel(
      this.created_by,
      this.genres,
      this.seasons,
      this.networks,
      this.vote_count,
      this.vote_average,
      this.status,
      this.backdrop_path,
      this.name,
      this.overview,
      this.poster_path,
      this.homepage,
      this.popularity,
      this.id,
      this.runtime,
      this.first_air_date);

  TVOverviewModel.fromJson(Map json)
      : created_by = json["created_by"],
        genres = json["genres"],
        seasons = json["seasons"],
        networks = json["networks"],
        vote_count = json["vote_count"],
        vote_average = json["vote_average"],
        status = json["status"],
        backdrop_path = json["backdrop_path"],
        name = json["name"] == null ? json["original_name"] : json["name"],
        overview = json["overview"],
        poster_path = json["poster_path"],
        homepage = json["homepage"],
        popularity = json["popularity"],
        id = json["id"],
        runtime = json["episode_run_time"][0],
        first_air_date = json["first_air_date"];
}

class TVOverview extends StatefulWidget {
  final int id;
  TVOverview({Key key, @required this.id}) : super(key: key);

  @override
  _TVOverviewState createState() => new _TVOverviewState();
}

class _TVOverviewState extends State<TVOverview> {

  Future<List<TVOverviewModel>> getInfo() async {

    List<TVOverviewModel> _data = [];

    String url = "https://api.themoviedb.org/3/tv/${widget.id}?"
        "api_key=b52e4d8c6e0b014ced7de2f7ea6f4284&language=en-US";

    http.Response res = await http.get(url);
    _data.add(new TVOverviewModel.fromJson(jsonDecode(res.body)));

    return _data;
  }

  Widget _backDropImage(AsyncSnapshot snapshot, double width) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          child: snapshot.data[0].backdrop_path != null
              ? Image.network(
                  "http://image.tmdb.org/t/p/w500" +
                      snapshot.data[0].backdrop_path,
                  fit: BoxFit.fill,
                  height: 180.0,
                  width: width,
                )
              : Image.asset(
                  "assets/images/no_image_detail.jpg",
                  fit: BoxFit.fill,
                  height: 180.0,
                  width: width,
                ),
        ),
        BottomGradient(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //int tvID = widget.id;

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: FutureBuilder(
            future: getInfo(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        backgroundColor: ThemeColor,
                        elevation: 8.0,
                        expandedHeight: 180.0,
                        title: Padding(
                        padding: snapshot.data[0].name != null
                        ? EdgeInsets.only(bottom: 4.0)
                            : EdgeInsets.only(bottom: 4.0),
                        child: Text(
                        snapshot.data[0].name != null ? snapshot.data[0].name : " ",
                        style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.ltr),
                        ),

                        actions: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              onPressed: null),
                          IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                              onPressed: null),
                        ],
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: _backDropImage(snapshot, width),
                        ),
                      ),
                    ];
                  },
                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _topHalf(snapshot),

                        //StoryLine
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 0.0, right: 0.0),
                          child: ExpansionTile(
                            title: Text(
                              "Synopsis",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            initiallyExpanded: true,
                            children: <Widget>[
                              _storyLine(snapshot),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: SizedBox(
                                    child: _genreList(snapshot),
                                    height: 40.0,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Season Info
                        ExpansionTile(
                            title: Text(
                              "Seasons",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            initiallyExpanded: false,
                            children: <Widget>[

                              SizedBox(
                                    height: 266.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: _seasonsCards(context, snapshot),
                                    )
                              ),

                            ],
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
                backgroundColor: ThemeColor,
              ));
            }),
      ),
      backgroundColor: Color(0x880D0D0D),
    );
  }

  Widget _topHalf(AsyncSnapshot snapshot) {
    return Row(
      children: <Widget>[
        _posterImage(snapshot),
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Column(
            children: <Widget>[

              Column(
                children: <Widget>[
                  /*
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 5.0),
                    child: _genreList(snapshot),
                  ),
                  */

                  //Release Date Text
                  Padding(
                    padding: EdgeInsets.only(top: 4.0, right: 77.0),
                    child: Text(
                        snapshot.data[0].first_air_date != null
                            ? snapshot.data[0].first_air_date
                            : "    ",
                        style: TextStyle(fontSize: 15.0, fontFamily: "Roboto"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.ltr),
                  ),

                  //Ratings
                  _starRating(snapshot),

                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 26.0),
                        child: FlatButton.icon(
                          splashColor: Colors.white,
                          onPressed: null,
                          icon: Icon(
                            Icons.tv,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Watch Trailer",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _seasonsCards(BuildContext context, AsyncSnapshot snapshot){
    return Column(
      children: <Widget>[
        //Search Results
        Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: SizedBox (
            child: _genSeasonCards(context, snapshot),
            height: 208.0,
          ),
        ),

      ],
    );
  }

  Widget _genSeasonCards(BuildContext context, AsyncSnapshot snapshot){

    if (snapshot.data[0].seasons != null){

      return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data[0].seasons.length,
          itemBuilder: (BuildContext context, int index){

            return Padding(
              padding: index == 0 ? const EdgeInsets.only(left: 18.0) :
              const EdgeInsets.only(left: 0.0),
              child: InkWell(
                onTap: () => print(snapshot.data[0].seasons[index]["id"]),
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
                              child: snapshot.data[0].seasons[index]["poster_path"] != null ?
                              Image.network("http://image.tmdb.org/t/p/w500" +
                                  snapshot.data[0].seasons[index]["poster_path"],
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
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Center(
                  child: Icon(Icons.movie,size: 80.0, color: Colors.grey,),
                ),
                Center(
                  child: Text("Couldn't find seasons",
                    style: TextStyle(
                        fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _posterImage(AsyncSnapshot snapshot) {
    double width = 115.0;
    double height = 160.0;

    return Padding(
      padding: const EdgeInsets.only(left: 13.0, top: 8.0, bottom: 42.0),
      child: Card(
        elevation: 8.0,
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(5.0),
          child: Center(
            child: snapshot.data[0].poster_path != null
                ? Image.network(
                    "http://image.tmdb.org/t/p/w500" +
                        snapshot.data[0].poster_path,
                    fit: BoxFit.fill,
                    height: height,
                    width: width,
                  )
                : Image.asset(
                    "assets/images/no_image_detail.jpg",
                    fit: BoxFit.fill,
                    height: height,
                    width: width,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _genreList(AsyncSnapshot snapshot){

    return Container(
      child: ListView.builder(
        itemCount: snapshot.data[0].genres.length == null ?
        0 : snapshot.data[0].genres.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index){
          return Container(
            child: Padding(
              padding: index != 0 ? EdgeInsets.only(left: 7.0, right: 2.0) :
              EdgeInsets.only(left: 21.0, right: 2.0),
              child: new Chip(
                label: Text(
                  snapshot.data[0].genres[index]["name"],
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

  Widget _infoString(AsyncSnapshot snapshot) {
    String info = "";

    info = snapshot.data[0].first_air_date == null
        ? ""
        : info +
            "" +
            snapshot.data[0].first_air_date.toString().substring(0, 4);

    info = snapshot.data[0].runtime == null
        ? ""
        : info + " | " + snapshot.data[0].runtime.toString() + "min";

    info = snapshot.data[0].status == null
        ? ""
        : info + " | " + snapshot.data[0].status;

    info = snapshot.data[0].networks[0]["name"] == null
        ? ""
        : info + " | " + snapshot.data[0].networks[0]["name"].toString();

    return Padding(
      padding: const EdgeInsets.only(top: 13.0),
      child: Container(
        child: Text(
          info,
          style: TextStyle(fontSize: 17.0),
        ),
      ),
    );
  }

  Widget _starRating(AsyncSnapshot snapshot) {
    if (snapshot.data[0].vote_average != null) {
      double rating = (snapshot.data[0].vote_average).toDouble();

      return Padding(
        padding: const EdgeInsets.only(left: 0.0, top: 7.0, right: 0.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 7.0, bottom: 6.0),
              child: Text(
                snapshot.data[0].vote_average.toString() == null
                    ? " "
                    : (snapshot.data[0].vote_average / 2).toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new StarRating(
                rating: rating / 2,
                color: primaryColor,
                borderColor: Colors.white,
                size: 21.0,
                starCount: 5,
              ),
            ),
            /*
          Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 12.0),
            child: Text(
              snapshot.data[0].vote_count.toString() == null
                  ? " "
                  : "(" + snapshot.data[0].vote_count.toString() + ")",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          */
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _storyLine(AsyncSnapshot snapshot) {
    return snapshot.data[0].overview != null
        ? Container(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 24.0, bottom: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  snapshot.data[0].overview != null
                      ? snapshot.data[0].overview
                      : "Storyline Unavailable",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Roboto",
                      color: Colors.white),
                  maxLines: 30,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          )
        : new Container();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

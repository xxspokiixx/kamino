import 'dart:async';
import 'dart:convert' as Convert;
import 'package:flutter_rating/flutter_rating.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:kamino/models/content.dart';
import 'package:kamino/models/movie.dart';
import 'package:kamino/models/tvshow.dart';

import 'package:kamino/api.dart' as api;
import 'package:kamino/res/BottomGradient.dart';
import 'package:kamino/ui/uielements.dart';
import 'package:kamino/view/content/movieLayout.dart';
import 'package:kamino/view/content/tvShowLayout.dart';

/*  CONTENT OVERVIEW WIDGET  */
///
/// The ContentOverview widget allows you to show information about Movie or TV show.
///
class ContentOverview extends StatefulWidget {
  final int contentId;
  final ContentOverviewContentType contentType;

  ContentOverview(
      {Key key, @required this.contentId, @required this.contentType})
      : super(key: key);

  @override
  _ContentOverviewState createState() => new _ContentOverviewState();
}

///
/// _ContentOverviewState is completely independent of the content type.
/// In the widget build section, you can add a reference to the body layout for your content type.
/// _data will be a ContentModel. You should look at an example model to cast this to your content type.
///
class _ContentOverviewState extends State<ContentOverview> {
  ContentModel _data;

  @override
  void initState() {
    // When the widget is initialized, download the overview data.
    loadDataAsync().then((data) {
      // When complete, update the state which will allow us to
      // draw the UI.
      setState(() {
        _data = data;
      });
    });
  }

  // Load the data from the source.
  Future<ContentModel> loadDataAsync() async {
    if(widget.contentType == ContentOverviewContentType.MOVIE){

      // Get the data from the server.
      http.Response response = await http.get(
        "${api.tvdb_root_url}/movie/${widget.contentId}${api.tvdb_default_arguments}"
      );
      String json = response.body;

      // Get the recommendations data from the server.
      http.Response recommendedDataResponse = await http.get(
        "${api.tvdb_root_url}/movie/${widget.contentId}/similar${api.tvdb_default_arguments}&page=1"
      );
      String recommended = recommendedDataResponse.body;

      // Return movie content model.
      return MovieContentModel.fromJSON(
          Convert.jsonDecode(json),
          recommendations: Convert.jsonDecode(recommended)["results"]
      );

    }else if(widget.contentType == ContentOverviewContentType.TV_SHOW){

      // Get the data from the server.
      http.Response response = await http.get(
          "${api.tvdb_root_url}/tv/${widget.contentId}${api.tvdb_default_arguments}"
      );
      String json = response.body;

      // Return TV show content model.
      return TVShowContentModel.fromJSON(Convert.jsonDecode(json));

    }

    throw new Exception("Unexpected content type.");
  }

  /* THE FOLLOWING CODE IS JUST LAYOUT CODE. */

  @override
  Widget build(BuildContext context) {
    // This is shown whilst the data is loading.
    if (_data == null) {
      return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor
              ),
            )
          )
        );
    }

    // When the data has loaded we can display the general outline and content-type specific body.
    return new Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              actions: <Widget>[
                IconButton(icon: Icon(Icons.favorite_border, color: Colors.white), onPressed: null),
              ],
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  _data.title,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontFamily: 'GlacialIndifference'
                  )
                ),
                background: _generateBackdropImage(context),
                collapseMode: CollapseMode.pin,
              ),
            ),
          ];
        },
        body: Scaffold(
          backgroundColor: Color(0xFF000000),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // This is the summary line, just below the title.
                _generateOverviewWidget(context),

                // Content Widgets
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: <Widget>[
                      /*
                        * If you're building a row widget, it should have a horizontal
                        * padding of 24 (narrow) or 16 (wide).
                        *
                        * If your row is relevant to the last, use a vertical padding
                        * of 5, otherwise use a vertical padding of 5 - 10.
                        *
                        * Relevant means visually and by context.
                      */
                      _generateGenreChipsRow(context),
                      _generateInformationCards(),

                      // Context-specific layout
                      _generateLayout(widget.contentType)
                    ],
                  )
                )
              ]
            )
          ),
        )
      )
    );
  }

  ///
  /// OverviewWidget -
  /// This is the summary line just below the title.
  ///
  Widget _generateOverviewWidget(BuildContext context){
    return new Padding(
      padding: EdgeInsets.only(bottom: 3.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                _data.releaseDate != "" ?
                  DateTime.parse(_data.releaseDate).year.toString() :
                  "Unknown",
                style: TextStyle(
                    fontFamily: 'GlacialIndifference',
                    fontSize: 16.0
                )
            ),
            new Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: new Text(
                    " \u2022 ",
                    style: TextStyle(
                        fontFamily: 'GlacialIndifference',
                        fontSize: 16.0
                    )
                )
            ),
            new Text(
                getOverviewContentTypeName(widget.contentType).toUpperCase(),
                style: TextStyle(
                    fontFamily: 'GlacialIndifference',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                )
            ),
            new Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: new Text(
                    " \u2022 ",
                    style: TextStyle(
                        fontFamily: 'GlacialIndifference',
                        fontSize: 16.0
                    )
                )
            ),
            StarRating(
              rating: _data.rating / 2, // Ratings are out of 10 from our source.
              color: Theme.of(context).primaryColor,
              borderColor: Theme.of(context).primaryColor,
              size: 16.0,
              starCount: 5,
            ),
            Text(
              " (${_data.voteCount})"
            )
          ]
      ),
    );
  }

  ///
  /// BackdropImage (Subwidget) -
  /// This controls the background image and stacks the gradient on top
  /// of the image.
  ///
  Widget _generateBackdropImage(BuildContext context){
    double contextWidth = MediaQuery.of(context).size.width;

    return Stack(
      fit: StackFit.expand,
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
            child: _data.backdropPath != null ?
            Image.network(
                api.tvdb_image_cdn + _data.backdropPath,
                fit: BoxFit.cover,
                height: 200.0,
                width: contextWidth
            ) :
            Image.asset(
                "assets/images/no_image_detail.jpg",
                fit: BoxFit.cover,
                height: 200.0,
                width: contextWidth
            )
        ),
        BottomGradient()
      ],
    );
  }

  ///
  /// GenreChipsRowWidget -
  /// This is the row of purple genre chips.
  /// TODO: When tapped, show a genre-filtered search.
  ///
  Widget _generateGenreChipsRow(context){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      child: Container(
        child: Center(child: ListView.builder(
          itemCount: _data.genres.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,

          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Padding(
                padding: index != 0
                    ? EdgeInsets.only(left: 6.0, right: 6.0)
                    : EdgeInsets.only(left: 6.0, right: 6.0),
                child: new Chip(
                  label: Text(
                    _data.genres[index]["name"],
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            );
          },
        ))
      )
    );
  }

  ///
  /// InformationCardsWidget-
  /// This generates cards containing basic information about the show.
  ///
  Widget _generateInformationCards(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        children: <Widget>[

          /* Synopsis */
          Column(
            children: <Widget>[
              ListTile(
                title: TitleText(
                    'Synopsis',
                    fontSize: 22.0,
                    textColor: Theme.of(context).primaryColor
                )
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.3, horizontal: 16.0),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 15.0
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _data.overview != "" ?
                            _data.overview :
                            // e.g: 'This TV Show has no synopsis available.'
                            "This " + getOverviewContentTypeName(widget.contentType) + " has no synopsis available.",
                          style: TextStyle(
                            color: Colors.grey
                          ),
                          maxLines: 8,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    )
                  )
                )
              )
            ],
          )
          /* ./Synopsis */


        ],
      )
    );
  }

  ///
  /// generateLayout -
  /// This generates the remaining layout for the specific content type.
  /// It is a good idea to reference another class to keep this clean.
  ///
  Widget _generateLayout(ContentOverviewContentType contentType){
    switch(contentType){
      case ContentOverviewContentType.TV_SHOW:
        // Generate TV show information
        return TVShowLayout.generate(context, _data);
      case ContentOverviewContentType.MOVIE:
        // Generate movie information
        return MovieLayout.generate(context, _data);
      default:
        return Container();
    }
  }
}

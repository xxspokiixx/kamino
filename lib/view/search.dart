import 'package:flutter/material.dart';
import 'package:kamino/main.dart';
import 'package:kamino/models/content.dart';
import 'package:kamino/view/content/overview.dart';
import 'package:kamino/res/BottomGradient.dart';
import 'search/bloc.dart';
import 'search/model.dart';
import 'search/provider.dart';

class SearchView extends StatefulWidget {
  @override
  SearchViewState createState() => new SearchViewState();
}

class SearchViewState extends State<SearchView> {
  final movieBloc = MovieBloc(API());
  final TextEditingController _searchControl = TextEditingController();

  _openContentScreen(BuildContext context, AsyncSnapshot snapshot, int index) {
    if (snapshot.data[index].mediaType == "tv") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ContentOverview(
                      contentId: snapshot.data[index].showID,
                      contentType: ContentOverviewContentType.TV_SHOW )
          )
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ContentOverview(
                      contentId: snapshot.data[index].showID,
                      contentType: ContentOverviewContentType.MOVIE )
          )
      );
    }
  }

  Widget _tvStream(BuildContext context, var movieBloc) {
    TextStyle _overLayTextFormat = new TextStyle(fontSize: 14.4);

    return StreamBuilder(
      stream: movieBloc.results,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Empty on first load
          //TODO: Add progress spinner after search term entered.
          return Container();

        } else if (snapshot.hasError) {
          return Center(child: CircularProgressIndicator());

        } else if (snapshot.data == null) {
          return Center(child: Text("Nothing to see here..."));

        } else {
          if (snapshot.data.length > 0) {
            print("...........I found ${snapshot.data.length}");
            print("...........I found ${snapshot.data[snapshot.data.length - 1].year.toString()}");
            print(".......");

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.76,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => _openContentScreen(context, snapshot, index),
                  splashColor: Colors.white,
                  child: Card(
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: new BorderRadius.circular(5.0),
                            child: Center(
                              child: snapshot.data[index].posterPath != null
                                  ? Image.network(
                                "http://image.tmdb.org/t/p/w500" +
                                    snapshot.data[index].posterPath,
                                fit: BoxFit.fill,
                                height: 752.0,
                                width: 500.0,
                              )
                                  : Container(
                                color: Colors.black,
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                            snapshot.data[index].title ==
                                                null
                                                ? const EdgeInsets.only(
                                                top: 65.0,
                                                right: 20.0)
                                                : const EdgeInsets.only(
                                                top: 48.0,
                                                left: 14.0,
                                                right: 11.0),
                                            child: Center(
                                              child: Text(
                                                snapshot.data[index].title !=
                                                    null
                                                    ? snapshot
                                                    .data[index].title
                                                    : "No Title",
                                                style: _overLayTextFormat,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                maxLines: snapshot
                                                    .data[index].title
                                                    .toString()
                                                    .length <
                                                    10
                                                    ? 1
                                                    : 3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          //BottomGradient(offset: 0.97),

                          _searchCardOverlay(snapshot, index, _overLayTextFormat),

                        ],
                      )),
                );
              },
            );
          } else {
            return Center(
                child: Text(
                  "We got nothing...",
                  style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'GlacialIndifference',
                      color: Colors.white70),
                ));
          }
        }
      },
    );
  }

  Widget _searchCardOverlay(
      AsyncSnapshot snapshot, int index, TextStyle _overLayTextFormat){

    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[

          ClipRRect(
            borderRadius: BorderRadius.circular(3.0),
            child: BottomGradient(offset: 0.98),
          ),

          Padding(
            padding: snapshot.data[index].title != null ?
            const EdgeInsets.only(top: 100.5):
            const EdgeInsets.only(top: 118.5),
            child: Column(
              children: <Widget>[

                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: snapshot.data[index].title == null ? Container() :
                      Text(snapshot.data[index].title,
                        style: _overLayTextFormat, textAlign: TextAlign.left,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: snapshot.data[index].mediaType ==
                            "movie"
                            ? EdgeInsets.only(
                            top: 4.0, left: 5.0, right: 3.0)
                            : EdgeInsets.only(
                            top: 4.0, left: 5.0, right: 4.0),
                        child:
                        snapshot.data[index].mediaType == "tv"
                            ? Icon(
                          Icons.live_tv,
                        )
                            : Icon(Icons.movie),
                      ),

                      //To address crashes caused by the API returning partial dates
                      //Will show null when partial dates is returned
                      _yearOverlay(snapshot, _overLayTextFormat, index),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

  Widget _yearOverlay(AsyncSnapshot snapshot, TextStyle _overLayTextFormat, int index){

    if (snapshot.data[index].year.toString().length < 3) {

      return Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 6.0),
        child: snapshot.data[index].year == null ? Container() :
        Text("null".substring(0,4),
          style: _overLayTextFormat, textAlign: TextAlign.left,
          maxLines: 1, overflow: TextOverflow.ellipsis,
        ),
      );

    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 6.0),
        child: snapshot.data[index].year == null ? Container() :
        Text(snapshot.data[index].year.toString().substring(0,4),
          style: _overLayTextFormat, textAlign: TextAlign.left,
          maxLines: 1, overflow: TextOverflow.ellipsis,
        ),
      );
    }

  }

  @override
  void dispose() {
    movieBloc.dispose();
    _searchControl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MovieProvider(
      movieBloc: MovieBloc(API()),
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: new Stack(
              alignment: Alignment(1.0, 0.0),
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: new PhysicalModel(
                      borderRadius: BorderRadius.circular(2.0),
                      elevation: 1.0,
                      color: Colors.transparent,
                      child: new Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 15.0),
                          child: new TextFormField(
                              controller: _searchControl,
                              autofocus: true,
                              autocorrect: true,
                              style: TextStyle(
                                  fontFamily: 'GlacialIndifference',
                                  fontSize: 18.0,
                                  color: Colors.white),
                              decoration: new InputDecoration.collapsed(
                                  hintText: "Search TV shows and movies...",
                                  hintStyle:
                                  TextStyle(color: Colors.grey)),
                              keyboardAppearance: Brightness.dark,
                              onEditingComplete: () {
                                movieBloc.query.add(_searchControl.text);
                              },
                              textInputAction: TextInputAction.search,
                              textCapitalization: TextCapitalization.words))),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.search,
                                size: 28.0, color: Colors.grey),
                            onPressed: () {
                              movieBloc.query.add(_searchControl.text);
                            })
                      ],
                    ))
              ],
            ),

            // MD2: make the color the same as the background.
            backgroundColor: backgroundColor,
            // Remove box-shadow
            elevation: 0.00,
          ),
          body: Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    child: Center(
                      child: StreamBuilder(
                        stream: movieBloc.log,
                        builder: (context, snapshot) => Container(
                          margin:
                          EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text(snapshot?.data ?? '',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontFamily: 'GlacialIndifference',
                                  fontSize: 15.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(child: _tvStream(context, movieBloc))
              ],
            ),
          )),
    );
  }

}

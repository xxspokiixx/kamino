import 'package:flutter/material.dart';
import 'package:kamino/main.dart';
import 'search/provider.dart';
import 'search/model.dart';
import 'search/bloc.dart';

class SearchView extends StatefulWidget {
  @override
  SearchViewState createState() => new SearchViewState();
}

class SearchViewState extends State<SearchView> {

  final movieBloc = MovieBloc(API());
  final TextEditingController _searchControl = TextEditingController();


  Widget _tvStream(BuildContext context, var movieBloc) {
    return StreamBuilder(
      stream: movieBloc.results,
      builder: (context, snapshot) {

        if (!snapshot.hasData) {

          // Empty on first load
          //TODO: Add progress spinner after search term entered.
          return Center();

        } else if (snapshot.hasError) {

          return Center(child: CircularProgressIndicator());

        } else if (snapshot.data == null) {
          return Center(child: Text("Nothing to see here..."));
        } else {

          if(snapshot.data.length > 0) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.76,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => print(snapshot.data[index].mediaType),
                  splashColor: Colors.blueAccent,
                  child: Card(
                    color: backgroundColor,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: ClipRRect(
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
                                  : Container()
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }else{
            return Center(child:
              Text(
                "We got nothing...",
                style: TextStyle(
                  fontSize: 26.0,
                  fontFamily: 'GlacialIndifference',
                  color: Colors.white70
                ),
              )
            );
          }
        }
      },
    );
  }

  _searchControlEditingComplete() {

  }

  @override
  void dispose(){
    movieBloc.dispose();
    _searchControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MovieProvider(
      movieBloc: MovieBloc(API()),

      child: MaterialApp(
        // Remove debug banner - because it's annoying.
        debugShowCheckedModeBanner: false,

        theme: new ThemeData(
            brightness: Brightness.dark,
            primaryColor: primaryColor,
            accentColor: Colors.lightBlue,
            splashColor: Colors.black,
            highlightColor: highlightColor,
            backgroundColor: backgroundColor,
            textSelectionHandleColor: Colors.lightBlue
        ),


        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,

            title: new Stack(
              alignment: Alignment(1.0, 0.0),
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: new PhysicalModel(
                    borderRadius: BorderRadius.circular(2.0),
                    elevation: 1.0,
                    color: Colors.white,
                    child: new Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                      child: new TextFormField(
                        controller: _searchControl,
                        autofocus: true,
                        autocorrect: true,
                        style: TextStyle(
                          fontFamily: 'GlacialIndifference',
                          fontSize: 18.0,
                          color: Colors.black
                        ),
                        decoration: new InputDecoration.collapsed(
                          hintText: "Search TV shows and movies...",
                          hintStyle: TextStyle(
                            color: Colors.black26
                          )
                        ),
                        keyboardAppearance: Brightness.dark,
                        onEditingComplete: (){
                          movieBloc.query.add(_searchControl.text);
                        },
                        textInputAction: TextInputAction.search,
                        textCapitalization: TextCapitalization.words
                      )
                    )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                            Icons.search,
                            size: 28.0,
                            color: Colors.black54
                        ),
                        onPressed: (){
                          movieBloc.query.add(_searchControl.text);
                        }
                      )
                    ],
                  )
                )
              ],
            ),

            // MD2: make the color the same as the background.
            backgroundColor: backgroundColor,
            // Remove box-shadow
            elevation: 0.00,
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  child: Center(
                    child: StreamBuilder(
                      stream: movieBloc.log,
                      builder: (context, snapshot) =>
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              snapshot?.data ?? '',
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'GlacialIndifference',
                                fontSize: 15.0
                              )
                            ),
                          ),
                    ),
                  ),
                ),
              ),
              Flexible(child: _tvStream(context, movieBloc))
            ],
          ),
        ),
      ),
    );
  }
}


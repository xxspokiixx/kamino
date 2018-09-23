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

  Widget _tvStream(BuildContext context, var movieBloc) {
    return StreamBuilder(
      stream: movieBloc.results,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
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
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final movieBloc = MovieBloc(API());
    TextEditingController _searchControl = TextEditingController();

    return MovieProvider(
      movieBloc: MovieBloc(API()),

      child: MaterialApp(
        // Remove debug banner - because it's annoying.
        debugShowCheckedModeBanner: false,

        theme: new ThemeData(
            brightness: Brightness.dark,
            primaryColor: primaryColor,
            accentColor: secondaryColor,
            splashColor: Colors.black,
            highlightColor: highlightColor,
            backgroundColor: backgroundColor
        ),
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(right: 17.0),
              child: new TextField(
                controller: _searchControl,
                autofocus: true,
                cursorColor: Colors.white,
                style: new TextStyle(
                  fontSize: 18.0,
                ),
                decoration: InputDecoration(
                    hintText: "Enter TV Show or Movie..."
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.search),
                  splashColor: Colors.white,
                  onPressed: () {
                    movieBloc.query.add(_searchControl.text);
                  })
            ],
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
                            child: Text(snapshot?.data ?? ''),
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


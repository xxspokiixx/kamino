import 'package:flutter/material.dart';
import 'package:kamino/animation/transition.dart';
import 'package:kamino/models/tvshow.dart';
import 'package:kamino/ui/uielements.dart';
import 'package:kamino/view/content/seasonOverview.dart';

class TVShowLayout{

  static Widget generate(BuildContext context, TVShowContentModel _data){
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
            children: <Widget>[

              /* Seasons Cards */
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                      title: TitleText(
                          'Seasons',
                          fontSize: 22.0,
                          textColor: Theme.of(context).primaryColor
                      )
                  ),

                  SizedBox(
                      height: 208.0,
                      child: _generateSeasonsCards(context, _data)
                  )
                ],
              )
              /* ./Seasons Cards */


            ]
        )
    );
  }

  static Widget _generateSeasonsCards(BuildContext context, TVShowContentModel _data){
    if(_data.seasons.length > 0){
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _data.seasons.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: index == 0
                ? const EdgeInsets.only(left: 18.0)
                : const EdgeInsets.only(left: 0.0),
            child: InkWell(
              onTap: (){
                _openEpisodesView(context, _data, index);
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
                            child: _data.seasons[index]["poster_path"] != null
                                ? Image.network(
                              "http://image.tmdb.org/t/p/w500" +
                                  _data.seasons[index]["poster_path"],
                              fit: BoxFit.fill,
                              height: 185.0,
                            ) : Image.asset(
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
    }
  }

  static void _openEpisodesView(
    BuildContext context,
    TVShowContentModel _data,
    int index
  ){
    List _payload = [
      _data.id,
      _data.seasons[index]["season_number"],
      _data.seasons,
    ];

    Navigator.push(
        context,
        SlideLeftRoute(builder: (context) => SeasonOverview(inputList: _payload))
    );
  }

}
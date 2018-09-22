import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_key.dart';

class Movie {
  final String mediaType;
  final int id;
  final String title, posterPath,backdropPath;

  Movie(this.mediaType, this.id, this.title, this.posterPath, this.backdropPath);

  String get tv => mediaType;
  String get checkPoster => posterPath;
  int get showID => id;

  Movie.fromJson(Map json)
      : mediaType = json["media_type"], id = json["id"],
        title = json["original_name"] == null ? json["name"]:json["original_name"],
        posterPath = json["poster_path"],
        backdropPath = json["backdrop_path"];


}

class API {
  final http.Client _client = http.Client();

  static const String _url =
      "https://api.themoviedb.org/3/search/multi?"
      "api_key=$api_key&language=en-US"
      "&query={1}&include_adult=false";


  Future<List<Movie>>  get(String query) async {
    List<Movie> list = [];

    await _client
        .get(Uri.parse(_url.replaceFirst("{1}", query)))
        .then((res) => res.body)
        .then(jsonDecode)
        .then((json) => json["results"])
        .then((movies) => movies.forEach((movie) => list.add(Movie.fromJson(movie))));


    for (int i = 0; i < list.length; i++){
      if (list[i].posterPath.toString() == null){
        list.removeAt(i);
      }

    }

    for (int i = 0; i < list.length; i++){
      if (list[i].mediaType.toString() == "person"){
        list.removeAt(i);
      }
    }

    return list;
  }
}
import 'package:kamino/models/content.dart';
import 'package:meta/meta.dart';

class MovieContentModel extends ContentModel {

  //final List reviews;
  final List recommendations;

  final String imdbId;
  final int runtime;

  MovieContentModel({
    // Content model inherited parameters
    @required int id,
    @required String title,
    String overview,
    String releaseDate,
    String homepage,
    List genres,
    double rating,
    String backdropPath,
    String posterPath,
    int voteCount,

    // Movie parameters
    //this.reviews,
    //this.recommendations,
    this.imdbId,
    this.runtime,
    this.recommendations
  }) : super( // Call the parent constructor...
    id: id,
    title: title,
    overview: overview,
    releaseDate: releaseDate,
    homepage: homepage,
    genres: genres,
    rating: rating,
    backdropPath: backdropPath,
    posterPath: posterPath,
    voteCount: voteCount
  );

  static MovieContentModel fromJSON(Map json, {
    List recommendations
  }){
    return new MovieContentModel(
      // Inherited properties.
      // (Copy-paste these to other models.)
      id: json["id"],
      title: json["title"],
      overview: json["overview"],
      releaseDate: json["release_date"],
      homepage: json["homepage"],
      genres: json["genres"],
      rating: json["vote_average"] != null ? json["vote_average"] : -1.0,
      backdropPath: json["backdrop_path"],
      posterPath: json["poster_path"],
      voteCount: json.containsKey("vote_count") ? json["vote_count"] : 0,

      // Object-specific properties.
      imdbId: json["imdb_id"],
      runtime: json["runtime"],
      recommendations: recommendations
    );
  }
}

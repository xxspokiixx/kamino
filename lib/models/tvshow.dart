import 'package:kamino/models/content.dart';
import 'package:meta/meta.dart';

class TVShowContentModel extends ContentModel {

  final List createdBy;
  final List episodeRuntime;
  final List seasons;
  final List networks;
  final String status;
  final double popularity;

  TVShowContentModel({
    // Content model inherited parameters
    @required int id,
    @required String title,
    String overview,
    String releaseDate,
    String homepage,
    List genres,
    List reviews,
    List recommendations,
    double rating,
    String backdropPath,
    String posterPath,
    int voteCount,
    double voteAverage,

    // Movie parameters
    this.createdBy,
    this.episodeRuntime,
    this.seasons,
    this.networks,
    this.status,
    this.popularity
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

  static TVShowContentModel fromJSON(Map json){
    return new TVShowContentModel(
      // Inherited properties.
      // (Copy-paste these to other models - it is fine to make small changes.)
      id: json["id"],
      title: json["name"] == null ? json["original_name"] : json["name"],
      overview: json["overview"],
      releaseDate: json["first_air_date"],
      homepage: json["homepage"],
      genres: json["genres"],
      rating: json["vote_average"] != null ? json["vote_average"] : -1,
      backdropPath: json["backdrop_path"],
      posterPath: json["poster_path"],
      voteCount: json["vote_count"] != null ? json["vote_count"] : 0,

      // Object-specific properties.
      createdBy: json["created_by"],
      episodeRuntime: json["episode_run_time"],
      seasons: json["seasons"],
      networks: json["networks"],
      status: json["status"],
      popularity: json["popularity"]
    );
  }

}

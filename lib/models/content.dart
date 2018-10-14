import 'package:flutter/material.dart';

/*  CONTENT TYPE DEFINITIONS  */
enum ContentOverviewContentType { MOVIE, TV_SHOW }
String getOverviewContentTypeName(ContentOverviewContentType type){
  switch(type) {
    case ContentOverviewContentType.MOVIE:
      return "Movie";
    case ContentOverviewContentType.TV_SHOW:
      return "TV Show";
    default:
      return "Unknown";
  }
}

class ContentModel {
  final int id;

  // Content Information
  final String title;
  final String overview;
  final String releaseDate; // For TV shows this is the first release date.
  final String homepage;

  // Content Classification
  final List genres;
  final double rating;
  final int voteCount;

  // Content Art.
  final String backdropPath;
  final String posterPath;

  ContentModel({
    @required this.id,
    @required this.title,
    this.overview,
    this.releaseDate,
    this.homepage,
    this.genres,
    this.rating,
    this.backdropPath,
    this.posterPath,
    this.voteCount
  });
}

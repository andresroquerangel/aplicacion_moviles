// Generated by https://quicktype.io

class PopularModel {
  String? backdropPath;
  List? genres;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  double? voteAverage;
  int? voteCount;
  String? videoUrl;

  PopularModel({
    this.backdropPath,
    this.genres,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.voteAverage,
    this.voteCount,
    this.videoUrl,
  });

  factory PopularModel.fromMap(Map<String, dynamic> movie) {
    return PopularModel(
      id: movie['id'],
      backdropPath: movie['backdrop_path'],
      genres: movie['genre_ids'],
      posterPath: movie['poster_path'],
      originalLanguage: movie['original_language'],
      originalTitle: movie['original_title'],
      overview: movie['overview'],
      popularity: movie['popularity'],
      releaseDate: movie['release_date'],
      title: movie['title'],
      voteAverage: movie['vote_average'],
      voteCount: movie['vote_count'],
      videoUrl: movie['key'],
    );
  }
}

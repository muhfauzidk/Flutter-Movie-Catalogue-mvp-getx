class MovieModel {
  int? id;
  String? title;
  String? overview;
  String? posterPath;
  String? backdropPath;
  double? voteAverage;
  int? voteCount;
  String? releaseDate;

  MovieModel({
    this.id,
    this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.voteCount,
    this.releaseDate,
  });

  MovieModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    backdropPath = json['backdrop_path'];
    voteAverage = json['vote_average']?.toDouble();
    voteCount = json['vote_count'] ?? 0;
    releaseDate = json['release_date'];
  }

  String getPosterUrl() {
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String getBackdropUrl() {
    return 'https://image.tmdb.org/t/p/w500$backdropPath';
  }
}

class MovieListResponse {
  int? page;
  int? totalResults;
  int? totalPages;
  List<MovieModel>? results;

  MovieListResponse({
    this.page,
    this.totalResults,
    this.totalPages,
    this.results,
  });

  MovieListResponse.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalResults = json['total_results'];
    totalPages = json['total_pages'];
    if (json['results'] != null) {
      results = <MovieModel>[];
      json['results'].forEach((v) {
        results!.add(MovieModel.fromJson(v));
      });
    }
  }
}

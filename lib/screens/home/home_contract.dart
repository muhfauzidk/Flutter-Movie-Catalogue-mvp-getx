import 'package:movie_catalogue_mvp_getx/data/models/movie_model.dart';

abstract class HomeContract {
  void showLoading();
  void hideLoading();
  void showMovies(List<MovieModel> movies);
  void showError(String message);
}

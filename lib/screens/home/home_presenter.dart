import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_catalogue_mvp_getx/data/models/movie_model.dart';
import 'package:movie_catalogue_mvp_getx/data/repositories/movie_repository.dart';
import 'package:movie_catalogue_mvp_getx/screens/home/home_binding.dart';
import 'package:movie_catalogue_mvp_getx/screens/home/home_contract.dart';

class HomePresenter extends GetxController implements HomeContract {
  HomePresenter(HomeBinding homeBinding);

  final ValueNotifier<List<MovieModel>> moviesNotifier = ValueNotifier([]);
  final ValueNotifier<int> totalMoviesNotifier = ValueNotifier(0);
  bool isDarkMode = false;
  RxBool isLoading = RxBool(false);

  int get totalMovies => totalMoviesNotifier.value;
  List<MovieModel> get movies => moviesNotifier.value;

  @override
  void onInit() {
    super.onInit();
    fetchMovies(totalMovies); // Fetch movies when the presenter is initialized
  }

  @override
  void onClose() {
    super.onClose();
    moviesNotifier.dispose(); // Dispose the ValueNotifier
    totalMoviesNotifier.dispose(); // Dispose the ValueNotifier
  }

  @override
  void showLoading() {
    isLoading.value = true;
  }

  @override
  void hideLoading() {
    isLoading.value = false;
  }

  @override
  void showMovies(List<MovieModel> movies) {
    moviesNotifier.value = movies;
  }

  @override
  void showError(String message) {
    // Handle error display if needed
  }

  void fetchMovies(int totalMovies) async {
    showLoading();
    Stopwatch stopwatch = Stopwatch()..start(); // Start the stopwatch
    try {
      final List<MovieModel> movies =
          await MovieRepository.fetchMovies(totalMovies);
      showMovies(movies);
    } catch (e) {
      showError('Error fetching movies');
    }
    stopwatch.stop(); // Stop the stopwatch
    print(
        'fetchMovies execution time: ${stopwatch.elapsed.inMilliseconds} milliseconds');

    hideLoading();
  }

  void searchMovies(String query) {
    final List<MovieModel> searchResults = movies
        .where((movie) =>
            movie.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
    showMovies(searchResults);
  }

  void changeTotalMovies(int total) {
    totalMoviesNotifier.value = total;
    fetchMovies(total); // Fetch movies when the total is changed
  }

  RxString filter = ''.obs;

  List<MovieModel> getFilteredMovies() {
    if (filter.value.isEmpty) {
      // No filter applied, return all movies
      return moviesNotifier.value;
    } else {
      // Apply filter based on movie title
      final lowerCaseFilter = filter.value.toLowerCase();
      return moviesNotifier.value.where((movie) {
        final title = movie.title?.toLowerCase() ?? '';
        return title.contains(lowerCaseFilter);
      }).toList();
    }
  }
}

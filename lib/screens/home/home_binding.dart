import 'package:get/get.dart';
import 'package:movie_catalogue_mvp_getx/data/models/movie_model.dart';
import 'package:movie_catalogue_mvp_getx/data/repositories/movie_repository.dart';
import 'package:movie_catalogue_mvp_getx/screens/home/home_contract.dart';
import 'package:movie_catalogue_mvp_getx/screens/home/home_presenter.dart';
import 'package:movie_catalogue_mvp_getx/screens/home/home_screen.dart';

class HomeBinding extends Bindings implements HomeContract {
  @override
  void dependencies() {
    Get.put<HomePresenter>(HomePresenter(this));
    Get.lazyPut<HomeScreen>(() => HomeScreen());
    Get.lazyPut<MovieRepository>(() => MovieRepository());
  }

  @override
  void showLoading() {
    // Implement showLoading method
    Get.find<HomePresenter>().isLoading.value = true;
  }

  @override
  void hideLoading() {
    // Implement hideLoading method
    Get.find<HomePresenter>().isLoading.value = false;
  }

  @override
  void showMovies(List<MovieModel> movies) {
    // Implement showMovies method
    Get.find<HomePresenter>().moviesNotifier.value = movies;
  }

  @override
  void showError(String message) {
    // Implement showError method
    // For example, you can display an error message in the UI.
    // Example:
    // Get.find<HomeScreen>().setState(() {
    //   // Display the error message in the UI
    // });
  }
}

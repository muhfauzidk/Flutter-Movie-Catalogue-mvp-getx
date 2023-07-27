import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movie_catalogue_mvp_getx/data/models/movie_model.dart';

class MovieRepository {
  static Future<List<MovieModel>> fetchMovies(int totalMovies) async {
    const apiKey = '2fe3e094d05ea48ef1cd132381a4708b';
    const int pageSize = 20;

    // Calculate the total number of pages required based on the total movies and page size
    final int totalPages = (totalMovies / pageSize).ceil();

    // Create an empty list to store all the fetched movies
    List<MovieModel> allMovies = [];

    for (int page = 1; page <= totalPages; page++) {
      final url = Uri.https(
        'api.themoviedb.org',
        '/3/movie/popular',
        {'api_key': apiKey, 'page': '$page'},
      );

      try {
        final response = await http.get(url);
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final movieListResponse = MovieListResponse.fromJson(jsonData);
          allMovies.addAll(movieListResponse.results!);

          // Check if we have fetched the desired number of movies
          if (allMovies.length >= totalMovies) {
            break;
          }
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }

    return allMovies;
  }
}

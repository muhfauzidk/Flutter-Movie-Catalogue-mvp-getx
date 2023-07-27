import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_catalogue_mvp_getx/data/models/movie_model.dart';
import 'package:movie_catalogue_mvp_getx/screens/detail_movie/detail_movie_screen.dart';
import 'package:movie_catalogue_mvp_getx/screens/home/home_presenter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomePresenter _presenter;

  double titleFontSize = 20.0;
  Color homeScreenBackgroundColor = Colors.white;

  void increaseTitleFontSize() {
    setState(() {
      titleFontSize += 5;
    });
  }

  void decreaseFontSize() {
    setState(() {
      titleFontSize -= 5;
    });
  }

  void changeBackgroundColor() {
    setState(() {
      homeScreenBackgroundColor = Colors.cyan;
    });
  }

  void changeToDefault() {
    setState(() {
      titleFontSize = 20.0;
      homeScreenBackgroundColor = Colors.white;
    });
  }

  @override
  void initState() {
    super.initState();
    _presenter = Get.find<HomePresenter>();
    _presenter.fetchMovies(20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeScreenBackgroundColor,
      appBar: AppBar(
        title: const Text("Movie Catalogue"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String? query = await showSearch<String?>(
                context: context,
                delegate: MovieSearchDelegate(
                  movies: _presenter.movies,
                ),
              );
              if (query != null) {
                _presenter.searchMovies(query);
              }
            },
          ),
          Builder(
            builder: (BuildContext context) {
              return PopupMenuButton<int>(
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Increase font size"),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Decrease font size"),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("Change background color"),
                  ),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: Text("Change to default"),
                  ),
                  const PopupMenuItem<int>(
                    value: 4,
                    child: Text("Total data"),
                  ),
                ],
                onSelected: (value) {
                  print("Selected value: $value");
                  if (value == 0) {
                    increaseTitleFontSize();
                  } else if (value == 1) {
                    decreaseFontSize();
                  } else if (value == 2) {
                    changeBackgroundColor();
                  } else if (value == 3) {
                    changeToDefault();
                  } else if (value == 4) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Select Total Movies'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _presenter.changeTotalMovies(100);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('100 Movies'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _presenter.changeTotalMovies(500);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('500 Movies'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _presenter.changeTotalMovies(1000);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('1.000 Movies'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _presenter.changeTotalMovies(5000);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('5.000 Movies'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _presenter.changeTotalMovies(10000);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('10.000 Movies'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              );
            },
          )
        ],
      ),
      body: Obx(
        () {
          final isLoading = _presenter.isLoading.value;
          final filteredMovies = _presenter.getFilteredMovies();

          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (filteredMovies.isEmpty) {
            return const Center(
              child: Text('No movies found.'),
            );
          } else {
            return ListView.separated(
              itemCount: filteredMovies.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.grey,
              ),
              itemBuilder: (context, index) {
                final movie = filteredMovies[index];
                return GestureDetector(
                  onTap: () {
                    Stopwatch stopwatch = Stopwatch()..start();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(
                          movie: movie,
                        ),
                      ),
                    );
                    print(
                        'Navigation duration: ${stopwatch.elapsedMilliseconds}ms');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            movie.getPosterUrl(),
                            height: 150,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title ?? '',
                                  style: TextStyle(
                                    fontSize: titleFontSize.toDouble(),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate<String?> {
  final List<MovieModel>? movies; // Pass the list of movies to the delegate

  MovieSearchDelegate({this.movies});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List searchResults = movies?.where((movie) {
          final title = movie.title ?? '';
          final lowerCaseTitle = title.toLowerCase();
          final lowerCaseQuery = query.toLowerCase();
          return lowerCaseTitle.contains(lowerCaseQuery);
        }).toList() ??
        [];

    return ListView.separated(
      itemCount: searchResults.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final MovieModel movie = searchResults[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            );
          },
          child: ListTile(
            title: Text(movie.title!),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List suggestions = movies?.where((movie) {
          final title = movie.title ?? '';
          final lowerCaseTitle = title.toLowerCase();
          final lowerCaseQuery = query.toLowerCase();
          return lowerCaseTitle.contains(lowerCaseQuery);
        }).toList() ??
        [];

    return ListView.separated(
      itemCount: suggestions.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final MovieModel movie = suggestions[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            );
          },
          child: ListTile(
            title: Text(movie.title!),
          ),
        );
      },
    );
  }
}

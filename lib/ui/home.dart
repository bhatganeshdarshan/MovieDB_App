import 'package:flutter/material.dart';
import 'package:movieapp/db/mysql_init.dart';
import 'package:movieapp/main.dart';
import 'package:movieapp/ui/bottom_navbar.dart';
import 'package:movieapp/ui/movie_details.dart';
import 'package:movieapp/ui/display_movies.dart';
import 'package:movieapp/ui/watchlist.dart';

class Movie {
  final String? movieId;
  final String? imageUrl;
  final String? title;
  final double? rating;

  Movie({
    required this.movieId,
    required this.imageUrl,
    required this.title,
    required this.rating,
  });
}

class HomePage extends StatefulWidget {
  final DatabaseService dbService;
  final String userIdentifier;
  const HomePage(
      {Key? key, required this.dbService, required this.userIdentifier})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> topMovies = [];
  List<Movie> newReleases = [];
  List<Movie> searchResults = [];
  bool isLoading = true;
  bool isSearching = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    connectSQL();
  }

  Future<void> connectSQL() async {
    String topMoviesQuery =
        "SELECT id,title, poster_url, rating FROM movies ORDER BY rating DESC LIMIT 10";
    var topMoviesData = await widget.dbService.executeQuery(topMoviesQuery);
    List<Movie> loadedTopMovies = [];
    for (final row in topMoviesData.rows) {
      loadedTopMovies.add(
        Movie(
          movieId: row.assoc()['id'].toString(),
          imageUrl: row.assoc()['poster_url'],
          title: row.assoc()['title'],
          rating: double.parse(row.assoc()['rating'].toString()),
        ),
      );
    }

    String newReleasesQuery =
        "SELECT id,title, poster_url, rating FROM movies ORDER BY release_date DESC LIMIT 10";
    var newReleasesData = await widget.dbService.executeQuery(newReleasesQuery);
    List<Movie> loadedNewReleases = [];
    for (final row in newReleasesData.rows) {
      loadedNewReleases.add(
        Movie(
          movieId: row.assoc()['id'].toString(),
          imageUrl: row.assoc()['poster_url'],
          title: row.assoc()['title'],
          rating: double.parse(row.assoc()['rating'].toString()),
        ),
      );
    }

    setState(() {
      topMovies = loadedTopMovies;
      newReleases = loadedNewReleases;
      isLoading = false;
    });
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
      return;
    }

    String searchQuery =
        "SELECT id,title, poster_url, rating FROM movies WHERE title LIKE '%$query%'";
    var searchData = await widget.dbService.executeQuery(searchQuery);
    List<Movie> results = [];
    for (final row in searchData.rows) {
      results.add(
        Movie(
          movieId: row.assoc()['id'].toString(),
          imageUrl: row.assoc()['poster_url'],
          title: row.assoc()['title'],
          rating: double.parse(row.assoc()['rating'].toString()),
        ),
      );
    }
    setState(() {
      searchResults = results;
      isSearching = true;
    });
  }

  void _onMovieTap(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MovieDetails(
                dbService: dbService,
                movieId: movie.movieId!,
                userIdentifier: "user123",
              )),
    );
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Tapped on ${movie.title}')),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          shadowColor: Colors.black45,
          title: SearchBar(
            onSearch: searchMovies,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.bookmark),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WatchlistPage(
                      dbService: widget.dbService,
                      userIdentifier: widget.userIdentifier,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: CategoryHeading(
                          title: "Top 10 Movies", dbService: widget.dbService),
                    ),
                    SizedBox(
                      height: 310,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        itemCount: isSearching
                            ? searchResults.length
                            : topMovies.length,
                        itemBuilder: (context, index) {
                          final movie = isSearching
                              ? searchResults[index]
                              : topMovies[index];
                          return GestureDetector(
                            onTap: () => _onMovieTap(context, movie),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 250,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: NetworkImage(movie.imageUrl!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      movie.title!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: CategoryHeading(
                        title: "New Releases",
                        dbService: widget.dbService,
                      ),
                    ),
                    SizedBox(
                      height: 310,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        itemCount: isSearching
                            ? searchResults.length
                            : newReleases.length,
                        itemBuilder: (context, index) {
                          final movie = isSearching
                              ? searchResults[index]
                              : newReleases[index];
                          return GestureDetector(
                            onTap: () => _onMovieTap(context, movie),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 250,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: NetworkImage(movie.imageUrl!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      movie.title!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: DefaultTabController(
            length: 2,
            child: BottomNavbar(
              dbService: widget.dbService,
              userIdentifier: widget.userIdentifier,
            )),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final void Function(String) onSearch;

  const SearchBar({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  bool _isActive = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!_isActive)
          Text("Movie Database App",
              style: Theme.of(context).appBarTheme.titleTextStyle),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: _isActive
                  ? Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0)),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: 'Search for something',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  widget.onSearch(_controller.text);
                                  setState(() {
                                    _isActive = false;
                                  });
                                },
                                icon: const Icon(Icons.search))),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _isActive = true;
                        });
                      },
                      icon: const Icon(Icons.search)),
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryHeading extends StatelessWidget {
  final String title;
  final DatabaseService dbService;
  const CategoryHeading({
    super.key,
    required this.title,
    required this.dbService,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MovieList(
                        dbService: dbService,
                      )),
            );
          },
          child: const Text(
            "See All",
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}

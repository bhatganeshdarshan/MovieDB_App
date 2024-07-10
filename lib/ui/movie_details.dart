import 'package:flutter/material.dart';
import 'package:movieapp/db/mysql_init.dart';

class Movie {
  final String? imageUrl;
  final String? title;
  final double? rating;
  final String? description;
  final String? release_date;

  Movie({
    required this.description,
    required this.release_date,
    required this.imageUrl,
    required this.title,
    required this.rating,
  });
}

class Director {
  final String? name;
  Director({
    required this.name,
  });
}

class Language {
  final String? name;
  Language({
    required this.name,
  });
}

class Genre {
  final String? name;
  Genre({
    required this.name,
  });
}

class Actors {
  final String? actor;
  Actors({
    required this.actor,
  });
}

class MovieDetails extends StatefulWidget {
  final DatabaseService dbService;
  final String movieId;
  final String userIdentifier; // Add userIdentifier to constructor

  const MovieDetails({
    super.key,
    required this.dbService,
    required this.movieId,
    required this.userIdentifier,
  }); // Include userIdentifier here

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<Movie> movies = [];
  List<Actors> actors = [];
  List<Director> directors = [];
  List<Language> languages = [];
  List<Genre> genres = [];
  bool isLoading = true;
  bool isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    String movieQuery =
        "SELECT id, title, poster_url, rating, description, release_date FROM movies WHERE id = :id";
    String actorsQuery =
        "SELECT a.name FROM actors a JOIN movie_actors ma ON a.id = ma.actor_id WHERE ma.movie_id = :id";
    String directorsQuery =
        "SELECT d.name FROM directors d JOIN movie_directors md ON d.id = md.director_id WHERE md.movie_id = :id";
    String languagesQuery =
        "SELECT l.name FROM languages l JOIN movie_lang ml ON l.id = ml.lang_id WHERE ml.movie_id = :id";
    String genresQuery =
        "SELECT g.name FROM genres g JOIN movie_genre mg ON g.id = mg.genre_id WHERE mg.movie_id = :id";

    var movieData =
        await widget.dbService.executeQuery(movieQuery, {"id": widget.movieId});
    var actorsData = await widget.dbService
        .executeQuery(actorsQuery, {"id": widget.movieId});
    var directorsData = await widget.dbService
        .executeQuery(directorsQuery, {"id": widget.movieId});
    var languagesData = await widget.dbService
        .executeQuery(languagesQuery, {"id": widget.movieId});
    var genresData = await widget.dbService
        .executeQuery(genresQuery, {"id": widget.movieId});

    List<Movie> loadedMovies = [];
    List<Actors> loadedActors = [];
    List<Director> loadedDirectors = [];
    List<Language> loadedLanguages = [];
    List<Genre> loadedGenres = [];

    for (final row in movieData.rows) {
      loadedMovies.add(
        Movie(
          imageUrl: row.assoc()['poster_url'],
          title: row.assoc()['title'],
          rating: double.parse(row.assoc()['rating'].toString()),
          description: row.assoc()['description'],
          release_date: row.assoc()['release_date'],
        ),
      );
    }
    for (final row in actorsData.rows) {
      loadedActors.add(Actors(actor: row.assoc()['name']));
    }
    for (final row in directorsData.rows) {
      loadedDirectors.add(Director(name: row.assoc()['name']));
    }
    for (final row in languagesData.rows) {
      loadedLanguages.add(Language(name: row.assoc()['name']));
    }
    for (final row in genresData.rows) {
      loadedGenres.add(Genre(name: row.assoc()['name']));
    }

    setState(() {
      movies = loadedMovies;
      actors = loadedActors;
      directors = loadedDirectors;
      languages = loadedLanguages;
      genres = loadedGenres;
      isLoading = false;
    });

    await checkWatchlistStatus();
  }

  Future<void> checkWatchlistStatus() async {
    String query = '''
    SELECT COUNT(*) AS count FROM watchlist 
    WHERE user_identifier = :user_identifier AND movie_id = :movie_id
  ''';

    var result = await widget.dbService.executeQuery(query, {
      "user_identifier": widget.userIdentifier,
      "movie_id": widget.movieId,
    });
    if (result.rows.isNotEmpty) {
      String? count = result.rows.first.assoc()['count'];
      setState(() {
        isInWatchlist = (count != null && count != "0") ? true : false;
      });
    } else {
      setState(() {
        isInWatchlist = false;
      });
    }
  }

  Future<void> addToWatchlist() async {
    String query = '''
      INSERT INTO watchlist (user_identifier, movie_id, added_date)
      VALUES (:user_identifier, :movie_id, NOW())
    ''';

    await widget.dbService.executeQuery(query, {
      "user_identifier": widget.userIdentifier,
      "movie_id": widget.movieId,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to Watchlist')),
    );

    setState(() {
      isInWatchlist = true;
    });
  }

  Future<void> removeFromWatchlist() async {
    String query = '''
      DELETE FROM watchlist 
      WHERE user_identifier = :user_identifier AND movie_id = :movie_id
    ''';

    await widget.dbService.executeQuery(query, {
      "user_identifier": widget.userIdentifier,
      "movie_id": widget.movieId,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed from Watchlist')),
    );

    setState(() {
      isInWatchlist = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 300.0,
                      floating: false,
                      pinned: true,
                      stretch: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        collapseMode: CollapseMode.parallax,
                        title: Text(movies.isNotEmpty ? movies[0].title! : '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            )),
                        background: movies.isNotEmpty
                            ? Image.network(
                                movies[0].imageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ),
                    ),
                  ];
                },
                body: ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber[700],
                            ),
                            Text(movies.isNotEmpty
                                ? movies[0].rating!.toString()
                                : '')
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () {
                            if (isInWatchlist) {
                              removeFromWatchlist();
                            } else {
                              addToWatchlist();
                            }
                          },
                          label: Text(
                            isInWatchlist
                                ? "Remove from Watchlist"
                                : "Add to Watchlist",
                            style: const TextStyle(color: Colors.blue),
                          ),
                          icon: Icon(
                            isInWatchlist ? Icons.remove : Icons.add,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      "Movie Description",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      movies.isNotEmpty ? movies[0].description! : '',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      "Actors",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ...actors.map((actor) => Text(
                          actor.actor!,
                          style: const TextStyle(fontSize: 16.0),
                        )),
                    const SizedBox(height: 16.0),
                    const Text(
                      "Directors",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ...directors.map((director) => Text(
                          director.name!,
                          style: const TextStyle(fontSize: 16.0),
                        )),
                    const SizedBox(height: 16.0),
                    const Text(
                      "Languages",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ...languages.map((language) => Text(
                          language.name!,
                          style: const TextStyle(fontSize: 16.0),
                        )),
                    const SizedBox(height: 16.0),
                    const Text(
                      "Genres",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ...genres.map((genre) => Text(
                          genre.name!,
                          style: const TextStyle(fontSize: 16.0),
                        )),
                  ],
                ),
              ),
      ),
    );
  }
}

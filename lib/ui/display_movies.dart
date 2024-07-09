import 'package:flutter/material.dart';
import 'package:movieapp/db/mysql_client.dart';
import 'package:movieapp/db/mysql_init.dart';
import 'package:movieapp/main.dart';
import 'package:movieapp/ui/movie_details.dart';
import 'package:movieapp/ui/home.dart';

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

class MovieList extends StatefulWidget {
  final DatabaseService dbService;

  const MovieList({Key? key, required this.dbService}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List<Movie> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    String query = "SELECT id, title, poster_url, rating FROM movies";
    var data = await widget.dbService.executeQuery(query);

    List<Movie> loadedMovies = [];
    for (final row in data.rows) {
      loadedMovies.add(
        Movie(
          movieId: row.assoc()['id'],
          imageUrl: row.assoc()['poster_url'],
          title: row.assoc()['title'],
          rating: double.parse(row.assoc()['rating'].toString()),
        ),
      );
    }
    setState(() {
      movies = loadedMovies;
      isLoading = false;
    });
  }

  void _onMovieTap(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MovieDetails(
                dbService: dbService,
                movieId: movie.movieId!,
              )),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tapped on ${movie.title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movies'),
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(dbService: widget.dbService),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return GestureDetector(
                    onTap: () => _onMovieTap(context, movie),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(movie.imageUrl!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title!,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber[700],
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        movie.rating.toString(),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
    );
  }
}

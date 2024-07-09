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

class MovieDetails extends StatefulWidget {
  final DatabaseService dbService;
  final String movieId;
  const MovieDetails(
      {super.key, required this.dbService, required this.movieId});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<Movie> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    String query =
        "SELECT id, title, poster_url, rating , description , release_date FROM movies where id =:id";
    var data =
        await widget.dbService.executeQuery(query, {"id": widget.movieId});

    List<Movie> loadedMovies = [];
    for (final row in data.rows) {
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
    setState(() {
      movies = loadedMovies;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: Text(movies[0].title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image.network(
                    movies[0].imageUrl!,
                    fit: BoxFit.cover,
                  ),
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
                      Text(movies[0].rating!.toString())
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {
                      print('Add to Watchlist clicked');
                    },
                    label: const Text("Add to Watchlist",
                        style: TextStyle(color: Colors.blue)),
                    icon: const Icon(
                      Icons.add,
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
                movies[0].description!,
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
              const Text(
                "Actor 1, Actor 2, Actor 3, Actor 4, Actor 5",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:movieapp/db/mysql_init.dart';
import 'package:movieapp/ui/movie_details.dart' as details;
import 'package:movieapp/ui/display_movies.dart' as display;

class WatchlistPage extends StatefulWidget {
  final DatabaseService dbService;
  final String userIdentifier;

  const WatchlistPage(
      {Key? key, required this.dbService, required this.userIdentifier})
      : super(key: key);

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  List<display.Movie> watchlistMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWatchlist();
  }

  Future<void> fetchWatchlist() async {
    String query = '''
      SELECT m.id, m.title, m.poster_url, m.rating 
      FROM watchlist w 
      JOIN movies m ON w.movie_id = m.id 
      WHERE w.user_identifier = :user_identifier
    ''';
    var data = await widget.dbService
        .executeQuery(query, {"user_identifier": widget.userIdentifier});
    List<display.Movie> loadedMovies = [];
    for (final row in data.rows) {
      loadedMovies.add(
        display.Movie(
          movieId: row.assoc()['id'].toString(),
          imageUrl: row.assoc()['poster_url'],
          title: row.assoc()['title'],
          rating: double.parse(row.assoc()['rating'].toString()),
        ),
      );
    }
    setState(() {
      watchlistMovies = loadedMovies;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: watchlistMovies.length,
                itemBuilder: (context, index) {
                  final movie = watchlistMovies[index];
                  return ListTile(
                    leading: Image.network(movie.imageUrl!),
                    title: Text(movie.title!),
                    subtitle: Text('Rating: ${movie.rating}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => details.MovieDetails(
                            dbService: widget.dbService,
                            movieId: movie.movieId!,
                            userIdentifier: "user123",
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

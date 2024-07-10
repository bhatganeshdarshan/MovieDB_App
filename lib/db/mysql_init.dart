import 'package:movieapp/ui/display_movies.dart';
import 'package:mysql_client/mysql_client.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  late final MySQLConnection _conn;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<void> connect() async {
    print("Connecting to MySQL server...");

    try {
      _conn = await MySQLConnection.createConnection(
        host: "mymoviedb7411-moviedb10.h.aivencloud.com",
        port: 28870,
        userName: "avnadmin",
        password: "AVNS_ayQVGzUcYKAAquVgIxH",
        databaseName: "moviedb",
      );

      await _conn.connect();
      print("Connected to MySQL server");
    } catch (e) {
      print("Failed to connect to MySQL server: $e");
    }
  }

  Future<void> disconnect() async {
    await _conn.close();
    print("Disconnected from MySQL server");
  }

  Future<IResultSet> executeQuery(String query,
      [Map<String, dynamic>? params]) async {
    return await _conn.execute(query, params);
  }

  Future<List<Movie>> fetchWatchlist(String userIdentifier) async {
    String query = """
      SELECT m.id, m.title, m.poster_url, m.rating 
      FROM watchlist w 
      JOIN movies m ON w.movie_id = m.id 
      WHERE w.user_identifier = :userIdentifier 
      ORDER BY w.added_date DESC
    """;

    var data = await executeQuery(query, {"userIdentifier": userIdentifier});
    List<Movie> watchlistMovies = [];

    for (final row in data.rows) {
      watchlistMovies.add(
        Movie(
          movieId: row.assoc()['id'].toString(),
          imageUrl: row.assoc()['poster_url'],
          title: row.assoc()['title'],
          rating: double.parse(row.assoc()['rating'].toString()),
        ),
      );
    }

    return watchlistMovies;
  }

  Future<void> addToWatchlist(String userIdentifier, int movieId) async {
    String query = """
      INSERT INTO watchlist (user_identifier, movie_id) 
      VALUES (:userIdentifier, :movieId)
    """;
    await executeQuery(query, {
      "userIdentifier": userIdentifier,
      "movieId": movieId,
    });
  }

  Future<void> removeFromWatchlist(String userIdentifier, int movieId) async {
    String query = """
      DELETE FROM watchlist 
      WHERE user_identifier = :userIdentifier AND movie_id = :movieId
    """;
    await executeQuery(query, {
      "userIdentifier": userIdentifier,
      "movieId": movieId,
    });
  }
}

class MovieRepository {
  final DatabaseService dbService;

  MovieRepository(this.dbService);

  Future<List<Map<String, dynamic>>> fetchMovies() async {
    List<Map<String, dynamic>> movies = [];
    await dbService.connect();
    String query = "SELECT id, poster_url FROM movies";
    var data = await dbService.executeQuery(query);

    for (final row in data.rows) {
      movies.add(row.assoc());
    }

    await dbService.disconnect();
    return movies;
  }
}

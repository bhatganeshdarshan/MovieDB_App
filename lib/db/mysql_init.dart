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

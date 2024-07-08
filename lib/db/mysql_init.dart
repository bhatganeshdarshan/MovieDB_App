import 'package:mysql1/mysql1.dart';
import 'dart:io';
import 'package:mysql_client/mysql_client.dart';

class MySqlService {
  final String host = 'mymoviedb7411-moviedb10.h.aivencloud.com';
  final int port = 28870;
  final String user = 'avnadmin';
  final String password = 'AVNS_ayQVGzUcYKAAquVgIxH';
  final String db = 'defaultdb';

  MySqlConnection? connection;

  Future<void> connect() async {
    try {
      connection = await MySqlConnection.connect(
        ConnectionSettings(
          host: host,
          port: port,
          user: user,
          password: password,
          db: db,
          useSSL: true,
        ),
      );
      print('Connected to Aiven for MySQL');
    } catch (e) {
      print('Error connecting to Aiven for MySQL: $e');
    }
  }

  Future<void> close() async {
    if (connection != null) {
      await connection!.close();
      print('Connection closed');
    }
  }

  Future<Results?> query(String sql, [List<dynamic>? values]) async {
    if (connection == null) {
      print('Not connected to the database');
      return null;
    }
    try {
      return await connection!.query(sql, values);
    } catch (e) {
      print('Error executing query: $e');
      return null;
    }
  }
}

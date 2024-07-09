import 'package:flutter/material.dart';
import 'package:movieapp/db/mysql_init.dart';
import 'package:movieapp/ui/home.dart';

final dbService = DatabaseService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbService.connect();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData.dark(),
      home: HomePage(dbService: dbService),
    );
  }
}

import 'package:flutter/material.dart';

class DisplayMovies extends StatefulWidget {
  const DisplayMovies({super.key});

  @override
  State<DisplayMovies> createState() => _DisplayMoviesState();
}

class _DisplayMoviesState extends State<DisplayMovies> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text("Display movies page "),
        ),
      ),
    );
  }
}

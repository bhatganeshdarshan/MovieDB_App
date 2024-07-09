import 'package:flutter/material.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
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
                  title: const Text("Movie Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image.network(
                    "https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
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
                      const Text("7.7/10")
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
              const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                "Vivamus lacinia odio vitae vestibulum vestibulum. "
                "Cras venenatis euismod malesuada. Nullam in urna vitae "
                "arcu vestibulum scelerisque. Donec auctor, justo quis "
                "accumsan porta, enim nisi facilisis risus, eget luctus "
                "nisi justo nec nunc.",
                style: TextStyle(fontSize: 16.0),
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

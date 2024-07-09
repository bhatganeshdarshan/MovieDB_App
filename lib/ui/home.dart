import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/db/mysql_client.dart';
import 'package:movieapp/db/mysql_init.dart';
import 'package:movieapp/ui/bottom_navbar.dart';
import 'package:movieapp/ui/custom_carousel.dart';
import 'package:movieapp/ui/display_movies.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late CarouselController _carouselController;
  // int _current = 0;

  // @override
  // void initState() {
  // //   super.initState();
  // //   _carouselController = CarouselController();
  // // }

  final MySqlService _mySqlService = MySqlService();
  String _statusMessage = 'Connecting to database...';

  @override
  void initState() {
    // _connectAndQuery();
    // connectSQL();
    super.initState();
  }

  // Future<void> _connectAndQuery() async {
  //   await _mySqlService.connect();
  //   if (_mySqlService.connection != null) {
  //     final results = await _mySqlService.query('SELECT * FROM test');
  //     if (results != null && results.isNotEmpty) {
  //       setState(() {
  //         _statusMessage =
  //             'Connected! Fetched ${results.length} rows from movies table.';
  //       });
  //     } else {
  //       setState(() {
  //         _statusMessage = 'Connected, but no data found in movies table.';
  //       });
  //     }
  //     await _mySqlService.close();
  //   } else {
  //     setState(() {
  //       _statusMessage = 'Failed to connect to database.';
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          shadowColor: Colors.black45,
          title: const SearchBar(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              MyCarousel(),
              // CarouselSlider(
              //   items: [
              //     Container(
              //       margin: const EdgeInsets.all(6.0),
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(8.0),
              //           image: const DecorationImage(
              //             image: NetworkImage(
              //                 "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"),
              //             fit: BoxFit.cover,
              //           )),
              //     ),
              //   ],
              //   options: CarouselOptions(
              //     height: 240.0,
              //     enlargeCenterPage: true,
              //     autoPlay: true,
              //     aspectRatio: 16 / 9,
              //     autoPlayCurve: Curves.fastOutSlowIn,
              //     enableInfiniteScroll: true,
              //     autoPlayAnimationDuration: const Duration(milliseconds: 800),
              //     viewportFraction: 0.8,
              //   ),
              // ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: CategoryHeading(title: "Top 10 Movies"),
              ),
              SizedBox(
                height: 310,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  children: [
                    _buildCard(Colors.green, "movie 1", () {}),
                    const SizedBox(
                      width: 40,
                    ),
                    _buildCard(Colors.blue, "movie 2", () {}),
                    const SizedBox(
                      width: 40,
                    ),
                    _buildCard(Colors.red, "movie 3", () {}),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: CategoryHeading(title: "New Releases"),
              ),
              SizedBox(
                height: 310,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  children: [
                    _buildCard(Colors.green, "movie 1", () {
                      print("clicked m1");
                    }),
                    const SizedBox(
                      width: 40,
                    ),
                    _buildCard(Colors.blue, "movie 2", () {
                      print("clicked m2");
                    }),
                    const SizedBox(
                      width: 40,
                    ),
                    _buildCard(Colors.red, "movie 3", () {
                      print("clicked m3");
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            const DefaultTabController(length: 3, child: BottomNavbar()),
        // floatingActionButton: FloatingActionButton(onPressed: () {}),
      ),
    );
  }

  Widget _buildCard(Color color, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        color: color,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}

class CategoryHeading extends StatelessWidget {
  final String title;
  const CategoryHeading({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            // print("clicked");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DisplayMovies()));
          },
          child: const Text(
            "See All",
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
        )
      ],
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!_isActive)
          Text("Movie Database App",
              style: Theme.of(context).appBarTheme.titleTextStyle),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: _isActive
                  ? Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0)),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Search for something',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isActive = false;
                                  });
                                },
                                icon: const Icon(Icons.close))),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _isActive = true;
                        });
                      },
                      icon: const Icon(Icons.search)),
            ),
          ),
        ),
      ],
    );
  }
}

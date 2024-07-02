import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/ui/bottom_navbar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            CarouselSlider(
              items: [
                Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: const DecorationImage(
                        image: NetworkImage(
                            "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"),
                        fit: BoxFit.cover,
                      )),
                ),
              ],
              options: CarouselOptions(
                height: 240.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
            ),
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
                  _buildCard(Colors.green, "movie 1"),
                  const SizedBox(
                    width: 40,
                  ),
                  _buildCard(Colors.blue, "movie 2"),
                  const SizedBox(
                    width: 40,
                  ),
                  _buildCard(Colors.red, "movie 3"),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: CategoryHeading(title: "New Releases"),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          const DefaultTabController(length: 3, child: BottomNavbar()),
    );
  }

  Widget _buildCard(Color color, String text) {
    return Container(
      width: 200,
      color: color,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 24),
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
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "See All",
          style: TextStyle(
            color: Colors.red,
            fontSize: 18,
          ),
        )
      ],
    );
  }
}

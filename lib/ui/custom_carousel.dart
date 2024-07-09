import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movieapp/ui/display_movies.dart';
import 'package:movieapp/ui/movie_details.dart';

class MyCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        GestureDetector(
          onTap: () {
            print('First item clicked');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MovieDetails()));
          },
          child: Container(
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: const DecorationImage(
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            print('Second item clicked');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MovieDetails()));
          },
          child: Container(
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: const DecorationImage(
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
    );
  }
}

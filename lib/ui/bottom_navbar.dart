import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 44, 43, 43),
      height: 70,
      child: const TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.home),
            text: "Home",
          ),
          Tab(
            icon: Icon(Icons.watch_later),
            text: "Watchlist",
          ),
          Tab(
            icon: Icon(Icons.photo_library_outlined),
            text: "New & Trending",
          ),
        ],
        indicatorColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Color(0xff999999),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:movieapp/db/mysql_init.dart';
import 'package:movieapp/ui/watchlist.dart';

class BottomNavbar extends StatelessWidget {
  final DatabaseService dbService;
  final String userIdentifier;

  const BottomNavbar(
      {Key? key, required this.dbService, required this.userIdentifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.new_releases),
          label: 'New Releases',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Watchlist',
        ),
      ],
      onTap: (index) {
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WatchlistPage(
                dbService: dbService,
                userIdentifier: userIdentifier,
              ),
            ),
          );
        }
      },
    );
  }
}

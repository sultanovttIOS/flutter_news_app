import 'package:flutter/material.dart';
import 'package:flutter_news_app/news_screen.dart';
import 'package:flutter_news_app/favorites_screen.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // MARK: Lifecycle

  @override
  void initState() {
    super.initState();
    setUpUI();
  }

  // MARK: Set up UI

  void setUpUI() {
    // В этом месте можно настроить UI, если потребуется.
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: TabBarView(
          children: [
            NewsScreen(),
            FavoritesScreen(),
          ],
        ),
        bottomNavigationBar: const TabBar(
          indicatorColor: Colors.purple,
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              icon: Icon(Icons.newspaper),
              text: 'News',
            ),
            Tab(
              icon: Icon(Icons.favorite),
              text: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}
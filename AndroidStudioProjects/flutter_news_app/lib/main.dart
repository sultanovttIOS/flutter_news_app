import 'package:flutter/material.dart';
import 'package:flutter_news_app/news_screen.dart';
import 'package:flutter_news_app/favorites_screen.dart';
import 'package:flutter_news_app/news_cell.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

// void main() {
//   List<News> newsList = [
//     News(
//       imageUrl: '',
//       title: 'Новость 1',
//       desc: 'Описание новости 1',
//       date: '10:30 AM',
//     ),
//     News(
//       imageUrl: '',
//       title: 'Новость 2',
//       desc: 'Описание новости 2',
//       date: '10:30 AM'),
//     // Добавьте другие новости сюда
//   ];
//
//   runApp(
//     MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Новости")),
//         body: ListView.builder(
//           itemCount: newsList.length,
//           itemBuilder: (context, index) {
//             return NewsCell(news: newsList[index]);
//           },
//         ),
//       ),
//     ),
//   );
// }

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
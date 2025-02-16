import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/news_model.dart';
import 'package:flutter_news_app/database/news_database.dart';

class DetailScreen extends StatefulWidget {
  final News news;

  const DetailScreen({super.key, required this.news});

  @override
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final db = NewsDatabase.instance;

    final favorites = await db.database;
    final result = await favorites.query(
      'favorite_news',
      where: 'id = ?',
      whereArgs: [widget.news.articleId],
    );

    setState(() {
      isLiked = result.isNotEmpty;
    });
  }

  Future<void> _toggleFavorite() async {
    await NewsDatabase.instance.toggleFavorite(widget.news);

    _checkIfFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final news = widget.news;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.network(
                  news.imageUrl ?? 'https://www.pasadenastarnews.com/wp-content/uploads/2025/02/PAS-L-WOONPA-0214-01.jpg?strip=all&w=1400px',
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16), // Отступ

              Text(
                news.title,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8), // Отступ

              // Источник новости
              Text(
                news.sourceName ?? '',
                style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16), // Отступ

              // Ссылка на новость
              Text(
                'Link: ${news.link ?? ''}',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 16), // Отступ

              // Дата публикации
              Text(
                'Published: ${news.pubDate ?? ''}',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16), // Отступ

              // Описание новости
              Text(
                news.description ?? '',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

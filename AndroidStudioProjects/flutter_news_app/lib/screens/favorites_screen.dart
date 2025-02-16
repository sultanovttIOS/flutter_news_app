import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/components/news_cell.dart';
import 'package:flutter_news_app/models/news_model.dart';
import 'package:flutter_news_app/screens/detail_news_screen.dart';
import 'package:flutter_news_app/database/news_database.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  final List<News> _newsList = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadLocalNews();
  }

  Future<void> _loadLocalNews() async {
    final localNews = await NewsDatabase.instance.getFavoriteNews();

    if (localNews.isNotEmpty) {
      print("✅ Найдено ${localNews.length} новостей в БД избранных.");
      setState(() {
        _newsList.clear();
        _newsList.addAll(localNews);
      });
    } else {
      // TODO: See Empty
    }
  }

  void _onNewsTapped(News news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(news: news),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _newsList.length,
        itemBuilder: (context, index) {
          if (index == _newsList.length) {
            return Center(child: CircularProgressIndicator());
          }

          final news = _newsList[index];
          return NewsCell(news: news,
            onTap: () => _onNewsTapped(news),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
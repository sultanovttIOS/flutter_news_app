import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../news_provider.dart';
import 'package:flutter_news_app/screens/components/news_cell.dart';
import 'package:flutter_news_app/database/news_database.dart';
import 'package:flutter_news_app/screens/detail_news_screen.dart' show DetailScreen;

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  NewsScreenState createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  final List<News> _newsList = [];
  String? _nextPage;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadLocalNews();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadLocalNews() async {
    final localNews = await NewsDatabase.instance.getNews();
    print("Загружаем новости из локальной БД...");

    if (localNews.isNotEmpty) {
      print("✅ Найдено ${localNews.length} новостей в БД.");
      setState(() {
        _newsList.clear();
        _newsList.addAll(localNews);
      });
    } else {
      print("⚠️ В БД нет новостей, загружаем из API.");
      _fetchNews();
    }
  }

  Future<void> _fetchNews() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);
    print("🔄 Началась загрузка новостей...");

     try {
      final newsResponse = await NewsProvider.getNews(nextPage: _nextPage);
      print("🌍 Получено ${newsResponse.results.length} новостей из API");

      await NewsDatabase.instance.insertNews(newsResponse.results);
      print("💾 Новости сохранены в БД.");

      setState(() {
        _newsList.addAll(newsResponse.results);
        _nextPage = newsResponse.nextPage;
        _hasMore = newsResponse.nextPage != null;
      });
    } catch (e) {
      print("❌ Ошибка загрузки новостей: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchNews();
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
        itemCount: _newsList.length + (_isLoading ? 1 : 0),
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
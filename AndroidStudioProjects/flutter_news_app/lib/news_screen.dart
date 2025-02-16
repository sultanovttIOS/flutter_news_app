import 'package:flutter/material.dart';
import 'news_model.dart';
import 'news_service.dart';
import 'package:flutter_news_app/news_cell.dart';
import 'package:flutter_news_app/database_helper.dart';
import 'package:flutter_news_app/detail_news_screen.dart';

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
    _loadLocalNews();  // Загрузим новости из БД при старте
    _scrollController.addListener(_scrollListener);
  }

  // Загрузка новостей из базы данных
  Future<void> _loadLocalNews() async {
    final localNews = await NewsDatabaseHelper.instance.getNews();
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

  // Загрузка новостей из API
  Future<void> _fetchNews() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);
    print("🔄 Началась загрузка новостей...");

    try {
      final newsResponse = await NewsService.fetchNews(nextPage: _nextPage);
      print("🌍 Получено ${newsResponse.results.length} новостей из API");

      // Сохраняем новости в базу данных
      await NewsDatabaseHelper.instance.insertNews(newsResponse.results);
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

  // Логика пагинации при прокрутке
  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchNews();
    }
  }

  // Обработчик нажатия на ячейку
  void _onNewsTapped(News news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(news: news), // Передаем новость на экран деталей
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

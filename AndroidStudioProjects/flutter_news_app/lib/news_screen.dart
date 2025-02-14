import 'package:flutter/material.dart';
import 'news_model.dart';
import 'news_service.dart';
import 'package:flutter_news_app/news_cell.dart';

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
    _fetchNews();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _fetchNews() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final newsResponse = await NewsService.fetchNews(nextPage: _nextPage);

      setState(() {
        _newsList.addAll(newsResponse.results);
        _nextPage = newsResponse.nextPage;
        _hasMore = newsResponse.nextPage != null;
      });
    } catch (e) {
      print('Ошибка загрузки новостей: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchNews();
    }
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
          return NewsCell(news: news);
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

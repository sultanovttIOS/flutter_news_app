import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_news_app/models/news_model.dart';

class NewsProvider {
  static const String _apiKey = 'pub_55238d2c462decee315a235f19ef3268c3b02';
  static const String _baseUrl = 'https://newsdata.io/api/1/news';

  static Future<NewsResponse> getNews({String? nextPage}) async {
    final url = Uri.parse(
        '$_baseUrl?apikey=$_apiKey&q=food&category=food${nextPage != null ? '&page=$nextPage' : ''}');
    try {
      final response = await http.get(url);
      print('URL: ${url}');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> newsJson = jsonData['results'];
        final List<News> newsList = newsJson.map((json) => News.fromJson(json)).toList();
        return NewsResponse(
          results: newsList,
          nextPage: jsonData['nextPage'],
        );
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Неизвестная ошибка: $e');
    }
  }
}


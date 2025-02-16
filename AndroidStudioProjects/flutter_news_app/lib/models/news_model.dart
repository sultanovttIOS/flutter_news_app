class NewsResponse {
  final List<News> results;
  final String? nextPage; // Токен для следующей страницы

  NewsResponse({required this.results, this.nextPage});
}

class News {
  final String articleId;  // Оставляем как строку
  final String title;
  final String? link;
  final String? description;
  final String? pubDate;
  final String? imageUrl;
  final String? sourceName;

  News({
    required this.articleId,
    required this.title,
    this.link,
    this.description,
    this.pubDate,
    this.imageUrl,
    this.sourceName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': articleId,  // Теперь оно совпадает со схемой БД
      'title': title,
      'link': link,
      'description': description,
      'pubDate': pubDate,
      'imageUrl': imageUrl,
      'sourceName': sourceName,
    };
  }

  static News fromMap(Map<String, dynamic> map) {
    return News(
      articleId: map['id'] ?? '',  // Убедимся, что поле правильное
      title: map['title'] ?? 'Без заголовка',
      link: map['link'] ?? '',
      description: map['description'] ?? '',
      pubDate: map['pubDate'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      sourceName: map['sourceName'] ?? '',
    );
  }

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      articleId: json['article_id'] ?? '',  // JSON использует snake_case
      title: json['title'] ?? 'Без заголовка',
      link: json['link'] ?? '',
      description: json['description'] ?? '',
      pubDate: json['pubDate'] ?? '',
      imageUrl: json['image_url'] ?? '',
      sourceName: json['sourceName'] ?? '',
    );
  }
}
class NewsResponse {
  final List<News> results;
  final String? nextPage; // Токен для следующей страницы

  NewsResponse({required this.results, this.nextPage});
}

class News {
  final String articleId;
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

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      articleId: json['article_id'] ?? '',
      title: json['title'] ?? 'Без заголовка',
      link: json['link'],
      description: json['description'],
      pubDate: json['pubDate'],
      imageUrl: json['image_url'],
      sourceName: json['sourceName'],
    );
  }
}


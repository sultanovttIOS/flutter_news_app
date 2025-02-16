import 'package:flutter/material.dart';
import 'package:flutter_news_app/news_model.dart';

class NewsCell extends StatelessWidget {
  final News news;
  final VoidCallback onTap;

  const NewsCell({super.key, required this.news, required this.onTap}); // Исправлено

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                news.imageUrl ?? 'https://www.pasadenastarnews.com/wp-content/uploads/2025/02/PAS-L-WOONPA-0214-01.jpg?strip=all&w=1400px',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 4),
              Text(
                news.title ?? 'Title',
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                news.description ?? 'Description',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                news.pubDate ?? 'Date',
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

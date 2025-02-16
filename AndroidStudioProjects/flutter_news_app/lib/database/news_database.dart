import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/news_model.dart';

class NewsDatabase {
  static final NewsDatabase instance = NewsDatabase._init();
  static Database? _database;

  NewsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('news.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }



  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE news(
      id TEXT PRIMARY KEY,
      title TEXT,
      link TEXT,
      description TEXT,
      pubDate TEXT,
      imageUrl TEXT,
      sourceName TEXT
    )
  ''');

    await db.execute('''
       CREATE TABLE favorite_news(
      id TEXT,
      title TEXT,
      link TEXT,
      description TEXT,
      pubDate TEXT,
      imageUrl TEXT,
      sourceName TEXT
    )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE new_news(
        id TEXT PRIMARY KEY,
        title TEXT,
        link TEXT,
        description TEXT,
        pubDate TEXT,
        imageUrl TEXT,
        sourceName TEXT
      )
    ''');
      // Перенос данных из старой таблицы
      await db.execute('''
      INSERT INTO new_news (id, title, link, description, pubDate, imageUrl, sourceName)
      SELECT id, title, link, description, pubDate, imageUrl, sourceName FROM news
    ''');
      await db.execute('DROP TABLE news');
      await db.execute('ALTER TABLE new_news RENAME TO news');
    }
  }


  Future<List<News>> getNews() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('news');

    print("📥 Загружено из БД: ${maps.length} записей");

    return List.generate(maps.length, (i) {
      print("📰 Новость из БД: ${maps[i]['title']}");
      return News.fromMap(maps[i]);
    });
  }


  Future<void> insertNews(List<News> newsList) async {
    final db = await database;
    final batch = db.batch();

    for (var news in newsList) {
      print("Добавляю в БД: ${news.title}");
      batch.insert('news', news.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
    print("✅ Новости успешно записаны в БД.");
  }

  Future<void> toggleFavorite(News news) async {
    final db = await instance.database;

    final result = await db.query(
      'favorite_news',
      where: 'id = ?',
      whereArgs: [news.articleId],
    );

    if (result.isEmpty) {
      await db.insert(
        'favorite_news',
        <String, Object?>{
          'id': news.articleId,
          'title': news.title,
          'link': news.link ?? '',
          'description': news.description ?? '',
          'pubDate': news.pubDate ?? '',
          'imageUrl': news.imageUrl ?? '',
          'sourceName': news.sourceName ?? '',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print("Новость добавлена в избранное с id: ${news.articleId}");
    } else {
      await db.delete(
        'favorite_news',
        where: 'id = ?',
        whereArgs: [news.articleId],
      );
      print("Новость удалена из избранного с id: ${news.articleId}");
    }
  }

  Future<List<News>> getFavoriteNews() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorite_news');

    print("📥 Загружено из БД избранных: ${maps.length} записей");

    return List.generate(maps.length, (i) {
      print("📰 Новость из  БД избранных: ${maps[i]['title']}");
      return News.fromMap(maps[i]);
    });
  }
}
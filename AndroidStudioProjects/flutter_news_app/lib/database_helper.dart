import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'news_model.dart';

class NewsDatabaseHelper {
  static final NewsDatabaseHelper instance = NewsDatabaseHelper._init();
  static Database? _database;

  NewsDatabaseHelper._init();

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
      version: 3, // Увеличиваем версию базы данных
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Указываем функцию для миграции
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

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'news.db');

    // Удаление базы данных
    await deleteDatabase(path);
    print('База данных удалена');
  }
}

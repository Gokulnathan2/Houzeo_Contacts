import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/models/contact_model.dart';

class DatabaseService {
  static Database? _database;
  static const String _tableName = 'contacts';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'contacts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id TEXT PRIMARY KEY,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        phoneNumber TEXT,
        email TEXT,
        company TEXT,
        jobTitle TEXT,
        profileImage TEXT,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<List<ContactModel>> getAllContacts() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'firstName ASC');
    return maps.map((map) => ContactModel.fromJson(map)).toList();
  }

  Future<List<ContactModel>> getFavoriteContacts() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'firstName ASC',
    );
    return maps.map((map) => ContactModel.fromJson(map)).toList();
  }

  Future<ContactModel?> getContactById(String id) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ContactModel.fromJson(maps.first);
    }
    return null;
  }

  Future<void> insertContact(ContactModel contact) async {
    final db = await database;
    await db.insert(_tableName, contact.toJson());
  }

  Future<void> updateContact(ContactModel contact) async {
    final db = await database;
    await db.update(
      _tableName,
      contact.toJson(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteContact(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleFavorite(String id) async {
    final db = await database;
    final contact = await getContactById(id);
    if (contact != null) {
      await db.update(
        _tableName,
        {'isFavorite': contact.isFavorite ? 0 : 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
} 
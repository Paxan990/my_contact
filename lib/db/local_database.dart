import 'package:my_contact/db/cached_contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._init();
  static Database? _database;

  factory LocalDatabase() {
    return getInstance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("contacts.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    const intType = "INTEGER DEFAULT 0";
    const boolType = 'BOOLEAN NOT NULL';
//TODO 2 Create table
    await db.execute('''
    CREATE TABLE $contactsTable (
    ${CachedContactsFields.id} $idType,
    ${CachedContactsFields.phone} $textType,
    ${CachedContactsFields.fullName} $textType
    )
    ''');
  }

  LocalDatabase._init();

//-------------------------------------------Cached Contacts Table------------------------------------

  static Future<CachedContact> insertCachedContact(CachedContact cachedContact) async {
    final db = await getInstance.database;
    final id = await db.insert(contactsTable, cachedContact.toJson());
    return cachedContact.copyWith(id: id);
  }

  static Future<int> deleteCachedContactById(int id) async {
    final db = await getInstance.database;
    var t = await db.delete(contactsTable, where: "${CachedContactsFields.id}=?", whereArgs: [id]);
    if (t > 0) {
      return t;
    } else {
      return -1;
    }
  }

  static Future<int> updateCachedContact({required CachedContact cachedContact}) async {
    Map<String, dynamic> row = {
      CachedContactsFields.phone: cachedContact.phone,
      CachedContactsFields.fullName: cachedContact.fullName,
    };
    final db = await getInstance.database;
    return await db.update(contactsTable, row, where: '${CachedContactsFields.id} = ?', whereArgs: [cachedContact.id]);
  }

  static Future<int> deleteAllCachedCategories() async {
    final db = await getInstance.database;
    return await db.delete(contactsTable);
  }

  static Future<List<CachedContact>> getAllCachedUser() async {
    final db = await getInstance.database;
    const orderBy = "${CachedContactsFields.fullName} ASC";
    final result = await db.query(contactsTable, orderBy: orderBy);
    return result.map((json) => CachedContact.fromJson(json)).toList();
  }
}

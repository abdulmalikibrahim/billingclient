import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/notification.dart';

class NotificationDB {
  static final NotificationDB instance = NotificationDB._();
  static Database? _database;

  NotificationDB._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'notifications.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE notifications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            image TEXT,
            is_read INTEGER DEFAULT 0,
            created_at TEXT
          )
        ''');
      },
    );
  }

  Future<int> insert(LocalNotification notif) async {
    final db = await database;
    return await db.insert('notifications', notif.toMap());
  }

  Future<List<LocalNotification>> getAll() async {
    final db = await database;
    final res = await db.query(
      'notifications',
      orderBy: 'created_at DESC',
    );
    return res.map((e) => LocalNotification.fromMap(e)).toList();
  }

  Future<void> markAsRead(int id) async {
    final db = await database;
    await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final db = await database;
    await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('notifications');
  }

  Future<void> markAllAsRead() async {
    final db = await database;
    await db.update('notifications', {'is_read': 1});
  }

  Future<int> countUnread() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM notifications WHERE is_read = 0',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<LocalNotification?> getByNotificationId(int notifId) async {
    final db = await database;

    final res = await db.query(
      'notifications',
      where: 'id = ?',
      whereArgs: [notifId],
      limit: 1,
    );

    if (res.isEmpty) return null;
    return LocalNotification.fromMap(res.first);
  }


}

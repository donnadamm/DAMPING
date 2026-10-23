import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase._internal();

  static final LocalDatabase instance = LocalDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'damping.db');

    return openDatabase(
      path,
      version: 3,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL UNIQUE,
            password_hash TEXT,
            role TEXT NOT NULL
              CHECK(role IN ('admin', 'guru', 'orang_tua')),
            identity_number TEXT,
            class_id INTEGER,
            student_id INTEGER,
            is_active INTEGER NOT NULL DEFAULT 1,
            created_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE classes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            homeroom_teacher_id INTEGER,
            created_at TEXT NOT NULL,
            FOREIGN KEY (homeroom_teacher_id)
              REFERENCES users(id) ON DELETE SET NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE students (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nis TEXT NOT NULL UNIQUE,
            name TEXT NOT NULL,
            class_id INTEGER,
            created_at TEXT NOT NULL,
            FOREIGN KEY (class_id)
              REFERENCES classes(id) ON DELETE SET NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE violation_types (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            points INTEGER NOT NULL,
            direct_sp TEXT,
            description TEXT,
            is_active INTEGER NOT NULL DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE sp_rules (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            min_points INTEGER NOT NULL,
            max_points INTEGER,
            created_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE violations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            student_id INTEGER NOT NULL,
            teacher_id INTEGER,
            violation_type_id INTEGER,
            violation_name TEXT NOT NULL,
            points INTEGER NOT NULL,
            direct_sp TEXT,
            description TEXT,
            evidence_path TEXT,
            status TEXT NOT NULL DEFAULT 'Menunggu Verifikasi Admin',
            sp_status TEXT NOT NULL DEFAULT 'Normal',
            parent_alert_sent INTEGER NOT NULL DEFAULT 0,
            sp_document_issued INTEGER NOT NULL DEFAULT 0,
            verified_by INTEGER,
            verification_note TEXT,
            occurred_at TEXT NOT NULL,
            created_at TEXT NOT NULL,
            FOREIGN KEY (student_id)
              REFERENCES students(id),
            FOREIGN KEY (teacher_id)
              REFERENCES users(id) ON DELETE SET NULL,
            FOREIGN KEY (violation_type_id)
              REFERENCES violation_types(id) ON DELETE SET NULL,
            FOREIGN KEY (verified_by)
              REFERENCES users(id) ON DELETE SET NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE notifications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            violation_id INTEGER,
            title TEXT NOT NULL,
            message TEXT NOT NULL,
            type TEXT NOT NULL,
            is_read INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL,
            FOREIGN KEY (user_id)
              REFERENCES users(id) ON DELETE CASCADE,
            FOREIGN KEY (violation_id)
              REFERENCES violations(id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE INDEX idx_students_class
          ON students(class_id)
        ''');

        await db.execute('''
          CREATE INDEX idx_users_student_id
          ON users(student_id)
          ''');

        await db.execute('''
          CREATE INDEX idx_violations_student
          ON violations(student_id)
        ''');

        await db.execute('''
          CREATE INDEX idx_violations_status
          ON violations(status)
        ''');

        await db.execute('''
          CREATE INDEX idx_notifications_user
          ON notifications(user_id, is_read)
        ''');

        // Kelas contoh agar formulir dan template CSV dapat langsung digunakan.
        await _seedDefaultClasses(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _seedDefaultClasses(db);
        }

        if (oldVersion < 3) {
          await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_users_student_id
      ON users(student_id)
    ''');
        }
      },
    );
  }

  Future<void> _seedDefaultClasses(Database db) async {
    final existing = await db.query('classes', columns: ['id'], limit: 1);
    if (existing.isNotEmpty) return;

    final now = DateTime.now().toIso8601String();
    const classNames = <String>[
      'X-A',
      'X-B',
      'XI-A',
      'XI-B',
      'XII-A',
      'XII-B',
    ];

    for (final className in classNames) {
      await db.insert('classes', <String, Object?>{
        'name': className,
        'created_at': now,
      });
    }
  }

  Future<int> insert(
    String table,
    Map<String, Object?> values,
  ) async {
    final db = await database;
    return db.insert(table, values);
  }

  Future<List<Map<String, Object?>>> getAll(
    String table, {
    String? orderBy,
  }) async {
    final db = await database;
    return db.query(table, orderBy: orderBy);
  }

  Future<int> updateById(
    String table,
    int id,
    Map<String, Object?> values,
  ) async {
    final db = await database;
    return db.update(
      table,
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteById(
    String table,
    int id,
  ) async {
    final db = await database;
    return db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

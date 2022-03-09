import 'package:noteefy/constants/db_constants.dart';
import 'package:noteefy/constants/db_query_constants.dart';
import 'package:noteefy/exceptions/db_exceptions.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConfig{
  // Database? _db;
  Database getDatabaseOrThrow(Database? _db) {
    final db = _db;
    return (db == null) ? throw DatabaseIsNotOpenException() : db;
  }

  Future<void> openDb(Database? _db) async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createUserTable);
      await db.execute(createNotesTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectoryException();
    }
  }

  Future<void> closeDb(Database? _db) async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }

  }
}
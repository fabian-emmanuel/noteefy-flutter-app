import 'package:noteefy/config/db_config.dart';
import 'package:noteefy/constants/db_constants.dart';
import 'package:noteefy/exceptions/db_exceptions.dart';
import 'package:noteefy/models/db_user.dart';
import 'package:sqflite/sqflite.dart';

class UserService {
  Database? _db;
  Future<void> deleteUser({required String email}) async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    final count = await db
        .delete(userTable, where: 'email=?', whereArgs: [email.toLowerCase()]);
    (count < 1) ? throw CouldNotDeleteUserException() : null;
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    final result = await db.query(userTable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);
    final userId = (result.isNotEmpty)
        ? throw UserAlreadyExistException()
        : await db.insert(userTable, {emailCol: email.toLowerCase()});
    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    final result = await db.query(userTable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);
    return (result.isEmpty)
        ? throw CouldNotFindUserException()
        : DatabaseUser.fromRow(result.first);
  }
}

import 'package:noteefy/config/db_config.dart';
import 'package:noteefy/constants/db_constants.dart';
import 'package:noteefy/exceptions/db_exceptions.dart';
import 'package:noteefy/models/db_notes.dart';
import 'package:noteefy/models/db_user.dart';
import 'package:noteefy/services/crud/user_service.dart';
import 'package:sqflite/sqflite.dart';

class NoteService {
  Database? _db;

  Future<DatabaseNote> createNote(
      {required DatabaseUser user, required String text}) async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    final dbUser = await UserService().getUser(email: user.email);
    final noteId = (dbUser != user)
        ? throw CouldNotFindUserException()
        : await db.insert(noteTable,
            {userIdCol: user.id, textCol: text, isSyncedWithCloudCol: 1});
    return DatabaseNote(
        id: noteId, userId: user.id, text: text, isSyncedWithCloud: true);
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseUser user,
      required int id,
      required String text}) async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    final dbUser = await UserService().getUser(email: user.email);
    final note = await getNote(id: id);
    final count = (dbUser.id != note.userId)
        ? throw PermissionDeniedException()
        : await db.update(noteTable, {textCol: text, isSyncedWithCloudCol: 0});
    return (count < 1)
        ? throw CouldNotUpdateNoteException()
        : getNote(id: id);
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    final result =
        await db.query(noteTable, limit: 1, where: 'id=?', whereArgs: [id]);
    return (result.isEmpty)
        ? throw CouldNotFindNoteException()
        : DatabaseNote.fromRow(result.first);
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    final notes = await db.query(noteTable);
    return (notes.isEmpty)
        ? throw CouldNotFindNoteException()
        : notes.map((note) => DatabaseNote.fromRow(note));
  }

  Future<void> deleteNote({required int id}) async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    final deleteCount =
        await db.delete(noteTable, where: 'id=?', whereArgs: [id]);
    (deleteCount != 1) ? throw CouldNotDeleteNoteException() : null;
  }

  Future<int> deleteAllNotes() async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    return await db.delete(noteTable);
  }
}

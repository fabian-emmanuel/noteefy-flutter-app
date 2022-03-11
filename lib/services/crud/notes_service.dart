import 'dart:async';

import 'package:noteefy/constants/db_constants.dart';
import 'package:noteefy/constants/db_query_constants.dart';
import 'package:noteefy/exceptions/db_exceptions.dart';
import 'package:noteefy/models/db_notes.dart';
import 'package:noteefy/models/db_user.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NoteService {
  Database? _db;

  List<DatabaseNote> _notes = [];

  static final NoteService _shared = NoteService._sharedInstance();

  NoteService._sharedInstance(){
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      }
    );
  }

  factory NoteService() => _shared;

  late final StreamController<List<DatabaseNote>> _notesStreamController;

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    return (db == null) ? throw DatabaseIsNotOpenException() : db;
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {}
  }

  Future<void> open() async {
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
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectoryException();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  //Note crud

  Future<DatabaseNote> createNote(
      {required DatabaseUser user}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: user.email);
    if(dbUser != user){
      throw CouldNotFindUserException();
    }
    const text = '';
    final noteId = await db.insert(noteTable,
            {userIdCol: user.id, textCol: text, isSyncedWithCloudCol: 1});
    final note = DatabaseNote(
        id: noteId, userId: user.id, text: text, isSyncedWithCloud: true);
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note,
      required String text}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final count = await db.update(noteTable, {textCol: text, isSyncedWithCloudCol: 0});
    if (count < 1) {
      throw CouldNotUpdateNoteException();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes =
        await db.query(noteTable, limit: 1, where: 'id=?', whereArgs: [id]);
    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      final note = DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount =
        await db.delete(noteTable, where: 'id=?', whereArgs: [id]);
    if (deleteCount != 1) {
      throw CouldNotDeleteNoteException();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final count = await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return count;
  }

  // User Crud

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUserException {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final count = await db
        .delete(userTable, where: 'email=?', whereArgs: [email.toLowerCase()]);
    (count < 1) ? throw CouldNotDeleteUserException() : null;
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(userTable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);
    final userId = (result.isNotEmpty)
        ? throw UserAlreadyExistException()
        : await db.insert(userTable, {emailCol: email.toLowerCase()});
    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(userTable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);
    return (result.isEmpty)
        ? throw CouldNotFindUserException()
        : DatabaseUser.fromRow(result.first);
  }
}

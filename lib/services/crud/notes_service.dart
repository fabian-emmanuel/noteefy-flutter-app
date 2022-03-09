import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noteefy/config/db_config.dart';
import 'package:noteefy/constants/db_constants.dart';
import 'package:noteefy/exceptions/db_exceptions.dart';
import 'package:noteefy/models/db_notes.dart';
import 'package:noteefy/models/db_user.dart';
import 'package:noteefy/services/crud/user_service.dart';
import 'package:sqflite/sqflite.dart';

class NoteService {
  Database? _db;
  List<DatabaseNote> _notes = [];
  final _notesStreamController =
      StreamController<List<DatabaseNote>>.broadcast();

  Future<void> cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes;
  }

  Future<DatabaseNote> createNote(
      {required DatabaseUser user, required String text}) async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    final dbUser = await UserService().getUser(email: user.email);
    final noteId = (dbUser != user)
        ? throw CouldNotFindUserException()
        : await db.insert(noteTable,
            {userIdCol: user.id, textCol: text, isSyncedWithCloudCol: 1});
    final note = DatabaseNote(
        id: noteId, userId: user.id, text: text, isSyncedWithCloud: true);
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
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
    if (count < 1) {
      throw CouldNotUpdateNoteException();
    } else {
      final note = await getNote(id: id);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    final notes =
        await db.query(noteTable, limit: 1, where: 'id=?', whereArgs: [id]);
    if (notes.isEmpty){
        throw CouldNotFindNoteException();
    } else{
      final note = DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<List<DatabaseNote>> getAllNotes() async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    final notes = await db.query(noteTable);
    return (notes.isEmpty)
        ? throw CouldNotFindNoteException()
        : notes.map((note) => DatabaseNote.fromRow(note)).toList();
  }

  Future<void> deleteNote({required int id}) async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    final deleteCount =
        await db.delete(noteTable, where: 'id=?', whereArgs: [id]);
    if (deleteCount != 1){
         throw CouldNotDeleteNoteException();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = DatabaseConfig().getDatabaseOrThrow(_db);
    final count =  await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return count;
  }
}

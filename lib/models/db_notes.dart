// import 'package:noteefy/constants/db_constants.dart';
//
//
// class DatabaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;
//
//   const DatabaseNote(
//       {required this.id,
//         required this.userId,
//         required this.text,
//         required this.isSyncedWithCloud});
//
//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idCol] as int,
//         userId = map[userIdCol] as int,
//         text = map[textCol] as String,
//         isSyncedWithCloud = (map[isSyncedWithCloudCol] as int) == 1 ? true : false;
//
//   @override
//   String toString() =>
//       'Note, id = $id, userId = $userId, text = $text, isSyncedWithCloud = $isSyncedWithCloud';
//
//   @override
//   bool operator ==(covariant DatabaseNote other) => id == other.id;
//
//   @override
//   int get hashCode => id.hashCode;
// }

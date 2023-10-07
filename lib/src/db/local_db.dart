import 'dart:async';
import 'package:edt/src/models/calendar.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

class LocalBdManager {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null && _db!.isOpen) {
      return _db!;
    } else {
      return await initDb();
    }
  }

  static Future close() async {
    if (_db != null) {
      await _db!.close();
    }
  }

  initDb() async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = openDatabase(
      join(await getDatabasesPath(), 'com.dinyad.edt.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
          'CREATE TABLE calendars (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, uri TEXT, color TEXT, checked INTEGER, added_at TEXT)',
        );
      },
      onUpgrade: (db, oldV, newV) async {
        if (newV > oldV) {
          //
        }
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    return database;
  }

  Future<int> insertCalenda(Calendar cal) async {
    final dab = await db;

    return dab.insert(
      'calendars',
      cal.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Calendar>> calendars() async {
    // Get a reference to the database.
    final dab = await db;

    // Query the table for all The notes.
    final List<Map<String, dynamic>> maps =
        await dab.query('calendars', orderBy: "id asc");

    // Convert the List<Map<String, dynamic> into a List<Searched>.
    return List.generate(maps.length, (i) {
      print(maps[i]);
      return Calendar.fromMapForDb(maps[i]);
    });
  }

  Future<List<Calendar>> checkedCalendars() async {
    // Get a reference to the database.
    final dab = await db;

    // Query the table for all The notes.
    final List<Map<String, dynamic>> maps = await dab.query('calendars',
        orderBy: "id asc", where: 'checked = ?', whereArgs: [1]);

    // Convert the List<Map<String, dynamic> into a List<Searched>.
    return List.generate(maps.length, (i) {
      return Calendar.fromMapForDb(maps[i]);
    });
  }

  Future<void> setCalendarChecked(int id, bool checked) async {
    // Get a reference to the database.
    final dab = await db;

    // Update the given Dog.
    await dab.update(
      'calendars',
      {"checked": checked ? 1 : 0},

      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteCalendar(int id) async {
    // Get a reference to the database.
    final dab = await db;

    await dab.delete(
      'calendars',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Future<void> updateSearched(Searched s) async {
  //   // Get a reference to the database.
  //   final dab = await db;

  //   // Update the given Dog.
  //   await dab.update(
  //     'search_history',
  //     s.toMap(),
  //     // Ensure that the Dog has a matching id.
  //     where: 'id = ?',
  //     // Pass the Dog's id as a whereArg to prevent SQL injection.
  //     whereArgs: [s.id],
  //   );
  // }

  // Future<void> deleteSearched(int id) async {
  //   // Get a reference to the database.
  //   final dab = await db;

  //   // Remove the Dog from the database.
  //   await dab.delete(
  //     'search_history',
  //     // Use a `where` clause to delete a specific dog.
  //     where: 'id = ?',
  //     // Pass the Dog's id as a whereArg to prevent SQL injection.
  //     whereArgs: [id],
  //   );
  // }

  // ///Messages

  // Future<int> insertMessage(ChatMessage msg) async {
  //   final dab = await db;

  //   return dab.insert(
  //     'messages',
  //     msg.toMapLocalDb(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // Future<void> updateMessage(ChatMessage msg) async {
  //   // Get a reference to the database.
  //   final dab = await db;

  //   // Update the given .
  //   await dab.update(
  //     'messages',
  //     msg.toMapLocalDb(),
  //     // Ensure that the Dog has a matching id.
  //     where: 'id = ?',
  //     // Pass the Dog's id as a whereArg to prevent SQL injection.
  //     whereArgs: [msg.id],
  //   );
  // }

  // // A method that retrieves all the notes from the notes table.
  // // uid : utilisateur connecté
  // Future<List<ChatMessage>> messages(String uid) async {
  //   // Get a reference to the database.
  //   final dab = await db;

  //   // Query the table for all The notes.
  //   final List<Map<String, dynamic>> maps =
  //       await dab.query('messages', orderBy: "sdate");

  //   // Convert the List<Map<String, dynamic> into a List<Searched>.
  //   return List.generate(maps.length, (i) {
  //     return ChatMessage(
  //       id: maps[i]['id'],
  //       messageType: ChatMessageType.text,
  //       messageStatus: ChatMessage.intToStatus(maps[i]['status']),
  //       text: maps[i]['contenu'],
  //       from: maps[i]['sfrom'],
  //       to: maps[i]['sto'],
  //       isSender: uid == maps[i]['sfrom'],
  //       sdate: maps[i]['sdate'],
  //     );
  //   });
  // }

  // Future<List<ChatMessage>> aUserMessages(String useruid) async {
  //   // Get a reference to the database.
  //   final dab = await db;

  //   // Query the table for all The notes.
  //   final List<Map<String, dynamic>> maps = await dab.query('messages',
  //       orderBy: "sdate",
  //       where: "sto = ? or sfrom = ?",
  //       whereArgs: [useruid, useruid]);

  //   // Convert the List<Map<String, dynamic> into a List<Searched>.
  //   return List.generate(maps.length, (i) {
  //     return ChatMessage(
  //       id: maps[i]['id'],
  //       messageType: ChatMessageType.text,
  //       messageStatus: ChatMessage.intToStatus(maps[i]['status']),
  //       text: maps[i]['contenu'],
  //       from: maps[i]['sfrom'],
  //       to: maps[i]['sto'],
  //       isSender: useruid == maps[i]['sto'],
  //       sdate: maps[i]['sdate'],
  //     );
  //     ;
  //   });
  // }

  // ///Chatusers

  // Future<bool> chatUserExists(String uid) async {
  //   final dab = await db;

  //   final List<Map<String, dynamic>> maps =
  //       await dab.query('chatusers', where: 'uid = ?', whereArgs: [uid]);
  //   return maps.isNotEmpty;
  // }

  // Future<void> insertChatuser(String uid) async {
  //   final dab = await db;
  //   ChatUser? u = await chatuser(uid);
  //   if (u == null) {
  //     UbnUser user = await UbeninFirebase.user(uid);
  //     await dab.insert(
  //       'chatusers',
  //       {
  //         "uid": uid,
  //         "nom": user.nom != null ? user.nom : "Nom",
  //         "avatar": user.avatar,
  //         "read": 0
  //       },
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   } else {
  //     u.read = false;
  //     await updateChatuser(u);
  //   }
  // }

  // Future<List<ChatUser>> chatusers() async {
  //   // Get a reference to the database.
  //   final dab = await db;

  //   // Query the table for all The notes.
  //   final List<Map<String, dynamic>> maps = await dab.query('chatusers');
  //   List<ChatUser> chatus = [];
  //   for (var map in maps) {
  //     List<ChatMessage> hisMsg = await aUserMessages(map["uid"]);
  //     chatus.add(ChatUser(
  //         id: map["id"],
  //         uid: map["uid"],
  //         nom: map["nom"],
  //         avatar: map["avatar"],
  //         read: hisMsg.last.to == map["uid"] ? true : map["read"] == 1,
  //         lastMgs: hisMsg.last));
  //   }

  //   chatus.sort((var c1, var c2) {
  //     return c2.lastMgs.sdate.compareTo(c1.lastMgs.sdate);
  //   });
  //   return chatus;
  // }

  // Future<ChatUser?> chatuser(String uid) async {
  //   // Get a reference to the database.
  //   final dab = await db;

  //   // Query the table for all The notes.
  //   final List<Map<String, dynamic>> maps =
  //       await dab.query('chatusers', where: 'uid = ?', whereArgs: [uid]);
  //   if (maps.isEmpty) {
  //     return null;
  //   }
  //   List<ChatMessage> hisMsg = await aUserMessages(uid);
  //   return ChatUser(
  //       id: maps[0]["id"],
  //       uid: maps[0]["uid"],
  //       nom: maps[0]["nom"],
  //       avatar: maps[0]["avatar"],
  //       read: maps[0]["read"] == 1 ? true : false,
  //       lastMgs: hisMsg.last);
  // }

  // Future<int> unreadChat() async {
  //   // Get a reference to the database.
  //   final dab = await db;

  //   // Query the table for all The notes.
  //   final List<Map<String, dynamic>> maps =
  //       await dab.query('chatusers', where: 'read = ?', whereArgs: [0]);

  //   return maps.length;
  // }

  // Future<void> updateChatuser(ChatUser user) async {
  //   // Get a reference to the database.
  //   final dab = await db;

  //   // Update the given .
  //   await dab.update(
  //     'chatusers',
  //     user.toMap(),
  //     // Ensure that the Dog has a matching id.
  //     where: 'id = ?',
  //     // Pass the Dog's id as a whereArg to prevent SQL injection.
  //     whereArgs: [user.id],
  //   );
  // }

  // Future<void> setStatus(String uid, bool val) async {
  //   // Get a reference to the database.
  //   final dab = await db;

  //   ChatUser? user = await chatuser(uid);
  //   if (user != null) {
  //     user.read = val;
  //     await updateChatuser(user);
  //   }
  // }

  // Future<void> storeInterets(List<String> list) async {
  //   // Get a reference to the database.
  //   final dab = await db;
  //   await dab.delete("interets");

  //   for (String s in list) {
  //     await dab.insert("interets", {"contenu": s});
  //   }
  // }

  // Future<List<String>> getInterets() async {
  //   final dab = await db;
  //   List<String> list = [];
  //   final List<Map<String, dynamic>> maps = await dab.query('interets');
  //   for (var map in maps) {
  //     list.add(map["contenu"]);
  //   }
  //   return list;
  // }
}

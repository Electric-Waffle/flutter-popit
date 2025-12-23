import "dart:io";

import "database_contact.dart";
import "sqlite_contact.dart";
import "sqflite_contact.dart";
import "./player.dart";

class PlayerDatabaseHelper {

  late final DatabaseContact _dbBackend;

  PlayerDatabaseHelper()
  {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      _dbBackend = SqliteContact();
    } else if (Platform.isAndroid || Platform.isIOS) {
      _dbBackend = SqfliteContact();
    } else {
      throw UnsupportedError('Plateforme non supportée');
    }
  }

  Future<void> createTables() async
  {
    await _dbBackend.createTables();
  }

  Future<void> openDatabase() async 
  {
    await _dbBackend.openTheDatabase(); // insertion du The pour éviter les conflite avec d'autres méthodes openDatabase (notemment pour sqflite)
  }

  Future<void> createPlayer() async 
  {
    await _dbBackend.createPlayer();
  }

  Future<void> saveData(Player joueur) async
  {
    await _dbBackend.saveData(joueur);
  }

  Future<Player> loadData() async
  {
    final Player player = await _dbBackend.loadData();
    return player;
  }
  
}
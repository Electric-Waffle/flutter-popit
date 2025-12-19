import "dart:io";

import "database_contact.dart";
import "./linux_contact.dart";
import "./player.dart";

class PlayerDatabaseHelper {

  late final DatabaseContact _dbBackend;

  PlayerDatabaseHelper()
  {
    if (Platform.isLinux) {
      this._dbBackend = LinuxContact();
    } else {
      throw UnsupportedError('Platforme non supportée');
    }
  }

  Future<void> createTables() async
  {
    await _dbBackend.createTables();
  }

  Future<void> openDatabase() async 
  {
    await _dbBackend.openDatabase();
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
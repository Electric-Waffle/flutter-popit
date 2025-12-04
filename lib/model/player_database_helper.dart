import "dart:ffi";

import "./database_helper.dart";
import "./player.dart";

class PlayerDatabaseHelper extends DatabaseHelper {

  @override
  void createTables()
  {
    db.execute('''
      CREATE TABLE IF NOT EXISTS player (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vie FLOAT,
        vie_base FLOAT,
        point INT
      );
    ''');
  }

  @override
  void openDatabase() {
    super.openDatabase();
    createPlayer();
  }

  void createPlayer() {

    final result = db.select('SELECT * FROM player');

    List<Player> resultInList = result
        .map((row) => Player(
              row['id'] as int,
              row['vie'] as double,
              row['vie_base'] as double,
              row['point'] as int,
            ))
        .toList();

    if (resultInList.isEmpty) {
      db.execute('''
        INSERT INTO player(vie, vie_base, point) values (10.0, 10, 0)
    ''');
    }
  }

  void saveData(Player joueur)
  {
    db.execute('UPDATE player SET vie = ? and vie_base = ? and points = ? where id = ?', [joueur.getVie(), joueur.getVieBase(), joueur.getPoints(), joueur.getId()]);
  }

  Player loadData()
  {
    final result = db.select('SELECT * FROM solar_system_object where id = 1');

    return  Player(
              result[0]['id'] as int,
              result[0]['vie'] as double,
              result[0]['vie_base'] as double,
              result[0]['point'] as int,
            );
  }
  
}
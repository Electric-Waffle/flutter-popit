import "dart:ffi";

import "(old)database_helper.dart";
import "../model/player.dart";
import "../model/linux_contact.dart";

class PlayerDatabaseHelper extends DatabaseHelper {

  @override
  void createTables()
  {
    db.execute('''
      CREATE TABLE IF NOT EXISTS player (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vie_base FLOAT,
        point INT,
        niveau_uppgrades TEXT
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
        .map((row) => Player.fromDatabase(
              row['id'] as int,
              row['vie_base'] as double,
              row['point'] as int,
              row['niveau_uppgrades'] as String,
            ))
        .toList();

    if (resultInList.isEmpty) {
      db.execute('''
        INSERT INTO player(vie_base, point, niveau_uppgrades) values (10.0, 0, '{}')
    ''');
    }
  }

  void saveData(Player joueur)
  {
    db.execute('UPDATE player set vie_base = ? , point = ?, niveau_uppgrades = ? where id = ?', [joueur.getVieBase(), joueur.getPoint(), joueur.getNiveauUppgradesSerialise(), joueur.getId()]);
  }

  Player loadData()
  {
    final result = db.select('SELECT * FROM player');

    return  Player.fromDatabase(
              result[0]['id'] as int,
              result[0]['vie_base'] as double,
              result[0]['point'] as int,
              result[0]['niveau_uppgrades'] as String,
            );
  }
  
}
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
        vie_base FLOAT,
        point INT,
        niveau_shop_vie INT
      );
    ''');
    // ICI
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
              row['vie_base'] as double,
              row['point'] as int,
              row['niveau_shop_vie'] as int,
            ))
            //ICI
        .toList();

    if (resultInList.isEmpty) {
      db.execute('''
        INSERT INTO player(vie_base, point, niveau_shop_vie) values (10.0, 0, 0)
    ''');
    // ICI
    }
  }

  void saveData(Player joueur)
  {
    db.execute('UPDATE player set vie_base = ? , point = ?, niveau_shop_vie = ? where id = ?', [joueur.getVieBase(), joueur.getPoint(), joueur.getNiveauShopVie(), joueur.getId()]);
  }// ICI

  Player loadData()
  {
    final result = db.select('SELECT * FROM player');

    return  Player(
              result[0]['id'] as int,
              result[0]['vie_base'] as double,
              result[0]['point'] as int,
              result[0]['niveau_shop_vie'] as int,
            );
  }// ICI
  
}
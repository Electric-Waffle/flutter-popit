import './player.dart';
import 'database_contact.dart';
import 'package:sqlite3/sqlite3.dart';

class LinuxContact implements DatabaseContact {
  late final Database db;

  /// Ouvre la base de données.
  @override
  Future<void> openDatabase() async {
    db = sqlite3.open('database.db');
    await createTables();
    await createPlayer();
  }

  /// Ferme la base de données.
  @override
  Future<void> closeDatabase() async {
    db.close();
  }

  /// Crée la tablea dans la base de donnée si elle n'existe pas
  @override
  Future<void> createTables() async
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

  /// Crée le joueur si il n'existe pas
  @override
  Future<void> createPlayer() async {

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

  /// Enregistre le joueur dans la base de donnée
  @override
  Future<void> saveData(Player joueur) async
  {
    db.execute('UPDATE player set vie_base = ? , point = ?, niveau_uppgrades = ? where id = ?', [joueur.getVieBase(), joueur.getPoint(), joueur.getNiveauUppgradesSerialise(), joueur.getId()]);
  }

  /// Charge les données de la base de données dans un joueur
  @override
  Future<Player> loadData() async
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
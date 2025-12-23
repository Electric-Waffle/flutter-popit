import './player.dart';
import 'database_contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class SqfliteContact implements DatabaseContact {
  late final Database db;

  /// Ouvre la base de données.
  @override
  Future<void> openTheDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'database.db');

    // attend que la DB soit ouverte
    db = await openDatabase(
      path,
      version: 1,
    );

    // maintenant la DB est dispo, on peut créer les tables
    await createTables();
    await createPlayer();
  }

  /// Ferme la base de données.
  @override
  Future<void> closeDatabase() async {
    await db.close();
  }

  /// Crée la tablea dans la base de donnée si elle n'existe pas
  @override
  Future<void> createTables() async
  {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS player (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vie_base REAL,
        point INTEGER,
        niveau_uppgrades TEXT
      );
    ''');
  }

  /// Crée le joueur si il n'existe pas
  @override
  Future<void> createPlayer() async {

    final result = await db.query('player'); // syntaxe spécifique sqflite

    List<Player> resultInList = result
        .map((row) => Player.fromDatabase(
              row['id'] as int,
              row['vie_base'] as double,
              row['point'] as int,
              row['niveau_uppgrades'] as String,
            ))
        .toList();

    if (resultInList.isEmpty) {
      await db.insert(
        'player', // table
        {
          'vie_base': 10.0, 
          'point': 0, 
          'niveau_uppgrades': '{}'
          }, // données
        conflictAlgorithm: ConflictAlgorithm.ignore, // ce qui se passe si ya un doublon
      );

    }
  }

  /// Enregistre le joueur dans la base de donnée
  @override
  Future<void> saveData(Player joueur) async
  {
    // approche sqflite, différente de sqlite :
    await db.update(
      'player', // table
      {
        'vie_base': joueur.getVieBase(), // Données
        'point': joueur.getPoint(),
        'niveau_uppgrades': joueur.getNiveauUppgradesSerialise(),
      },
      where: 'id = ?', // condition
      whereArgs: [joueur.getId()], // insertion de la donnée dans la condition pour éviter injection
    );
  }

  /// Charge les données de la base de données dans un joueur
  @override
  Future<Player> loadData() async
  {
    final result = await db.query('player', limit: 1); // syntaxe spécifique sqflite

    return  Player.fromDatabase(
              result[0]['id'] as int,
              result[0]['vie_base'] as double,
              result[0]['point'] as int,
              result[0]['niveau_uppgrades'] as String,
            );
  }

}
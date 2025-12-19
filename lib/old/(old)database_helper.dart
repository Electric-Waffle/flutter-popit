import 'package:sqlite3/sqlite3.dart';

/// Classe abstraite de base pour la gestion de la base de données.
abstract class DatabaseHelper {
  /// Instance de la base de données
  late final Database db;

  /// Constructeur qui initialise et ouvre la base de données.
  DatabaseHelper() {
    openDatabase();
  }

  /// Ouvre la base de données.
  void openDatabase() {
    db = sqlite3.open('database.db');
    createTables();
  }

  /// Méthode abstraite pour créer les tables dans la base de données.
  /// Doit être implémentée dans les classes dérivées.
  void createTables();

  /// Ferme la base de données.
  void closeDatabase() {
    db.dispose();
  }
}

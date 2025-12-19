import './player.dart';

abstract class DatabaseContact {
  Future<void> openDatabase();
  Future<void> createTables();
  Future<void> closeDatabase();
  Future<void> createPlayer();
  Future<void> saveData(Player joueur);
  Future<Player> loadData();
}
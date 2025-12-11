import 'dart:convert';
import './player_database_helper.dart';
import 'package:flutter/foundation.dart';

class Player {

  late int _id;

  late double _vie;
  late double _vieBase;

  late int _point;

  late Map<String,int> _niveauUppgrades;

  Player(int this._id, double this._vieBase, int this._point, this._niveauUppgrades)
  {
    this._vie = this._vieBase;
  }

  @factory
  Player.fromDatabase(int this._id, double this._vieBase, int this._point, niveauUppgradesSerialise)
  {
    this._vie = this._vieBase;
    setNiveauUppgradesSerialise(niveauUppgradesSerialise);
  }

  int getId()
  {
    return this._id;
  }

  double getVie()
  {
    return this._vie;
  }
  double getVieBase()
  {
    return this._vieBase;
  }

  int getPoint()
  {
    return this._point;
  }

  Map<String,int> getNiveauUppgrades()
  {
    return this._niveauUppgrades;
  }

  void setId(int id)
  {
    this._id = id;
  }

  void setVie(double vie)
  {
    this._vie = vie;
  }

  void setVieBase(double vieBase)
  {
    this._vieBase = vieBase;
  }

  void setPoint(int point)
  {
    this._point = point;
  }

  void setNiveauUppgrades (Map<String,int> niveauUppgrades)
  {
    this._niveauUppgrades = niveauUppgrades;
  }

  void setNouvelleUppgrade (String nouvelleUppgrade)
  {
    this._niveauUppgrades[nouvelleUppgrade] = 0;
  }

  void doDamage(int damage)
  {
    setVie( getVie() - damage );
  }

  void doGivePoints(int points)
  {
    setPoint( getPoint() + points );
  }

  void doBuyUppgrade(int cost)
  {
    setPoint( getPoint() - cost );
  }

  void setLeNiveauDeUneUppgrade (String uppgrade, int niveauUppgrade)
  {
    this._niveauUppgrades[uppgrade] = niveauUppgrade;
  }

  int getLeNiveauDeUneUppgrade (String uppgrade)
  {
    if (_niveauUppgrades[uppgrade] == null) {
      createNouvelUppgradePourJoueur(uppgrade);
    }
    return _niveauUppgrades[uppgrade] ?? 0;
  }

  void createNouvelUppgradePourJoueur(String nomDeUppgrade)
  {
    setNouvelleUppgrade(nomDeUppgrade);
    PlayerDatabaseHelper.saveData(this);
  }

  String getNiveauUppgradesSerialise ()
  {
    return jsonEncode(getNiveauUppgrades());
  }

  void setNiveauUppgradesSerialise (String niveauUppgradesSerialise)
  {
    Map<String, dynamic> niveauUppgradesDeserialise = jsonDecode(niveauUppgradesSerialise);
    setNiveauUppgrades(niveauUppgradesDeserialise.map((key, value) => MapEntry(key, value as int)));
  }

  void doUppgradeShop(String uppgrade, int cost)
  {

    doBuyUppgrade(cost);
    setLeNiveauDeUneUppgrade(uppgrade, getLeNiveauDeUneUppgrade(uppgrade)+1);

  // Les effets de l'uppgrade, si il faut.
    switch (uppgrade) {

      case "Vie":
        setVieBase(getVieBase()+10);
        break;

      default:
        break;
    }
  }

  void reloadPlayer(Player newPlayer)
  {
    setId(newPlayer.getId());
    setVieBase(newPlayer.getVieBase());
    setVie(newPlayer.getVie());
    setPoint(newPlayer.getPoint());
  }

  bool isAlive()
  {
    if (getVie()>0.0) {
      return true;
    }
    return false;
  }
  
}
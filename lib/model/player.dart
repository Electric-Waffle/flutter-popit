import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:math';

class Player {

  late int _id;

  late double _vie;
  late double _vieBase;

  late int _combo;
  late int _comboMax;

  late int _revive;

  late int _point;

  late Map<String,int> _niveauUppgrades;

  Player(int this._id, double this._vieBase, int this._point, this._niveauUppgrades)
  {
    this._vie = this._vieBase;
    this._combo = 0;
    this._comboMax = 0;
    this._revive = 0;
  }

  @factory
  Player.fromDatabase(int this._id, double this._vieBase, int this._point, niveauUppgradesSerialise)
  {
    this._vie = this._vieBase;
    this._combo = 0;
    this._comboMax = 0;
    setNiveauUppgradesSerialise(niveauUppgradesSerialise);
    this._revive = getLeNiveauDeUneUppgrade("Ankh");
  }

  int getRevive ()
  {
    return this._revive;
  }

  int getCombo()
  {
    return this._combo;
  }

  int getComboMax()
  {
    return this._comboMax;
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

  void setRevive (int revive)
  {
    this._revive = revive;
  }

  void setCombo(int combo)
  {
    this._combo = combo;
  }

  void setComboMax(int comboMax)
  {
    this._comboMax = comboMax;
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

  void incrementCombo()
  {
    if (getLeNiveauDeUneUppgrade("Dernier profit") > 0)
    {
      setCombo(getCombo()+1);

      if (getCombo() > getComboMax()) {
        setComboMax(getCombo());
      }
    }
  }

  void resetCombo()
  {
    setCombo(0);
  }

  void cashoutCombo() {

    if (getCombo() > getComboMax()) {
      doGivePoints((getCombo()*getLeNiveauDeUneUppgrade("Dernier profit")).toInt());
    }
    else 
    {
      doGivePoints((getComboMax()*getLeNiveauDeUneUppgrade("Dernier profit")).toInt());
    }

    //setCombo(0);
    //setComboMax(0);

  }

  void doDamage(double damage)
  {
    double reductionDegat = (getLeNiveauDeUneUppgrade("Armure") / 100) * damage;
    double damageFinal = damage - reductionDegat;
    setVie( getVie() - (damageFinal) );
  }

  void doGivePoints(int points)
  {

    points += getLeNiveauDeUneUppgrade("Investissement");

    if (getVie() > getVieBase()*0.9)
    {
      points += getLeNiveauDeUneUppgrade("Soleil");
    }

    if (evenementAleatoire(getLeNiveauDeUneUppgrade("Patte de Lapin").toDouble()))
    {
      points += points;
    }

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
    return _niveauUppgrades[uppgrade] ?? 0;
  }

  bool isUppgradeDansJoueur(String nomDeUppgrade)
  {
    return (_niveauUppgrades.containsKey(nomDeUppgrade));
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

  bool evenementAleatoire(double pourcentageDeChance) {
    final aleatoire = Random();
    
    // Génère un nombre entre 0.0 et < 100.0
    double roll = aleatoire.nextDouble() * 100;

    return roll < pourcentageDeChance;
  }

  void activeUppgradeFaucheuse()
  {
    if (evenementAleatoire(getLeNiveauDeUneUppgrade("Faucheuse").toDouble()*2)) {
      giveVie(1.0);
    }
  }

  void giveVie(double vie)
  {
    setVie(getVie()+vie);
    limiteVie();
  }

  void limiteVie()
  {
    if (getVie() > getVieBase())
    {
      setVie(getVieBase());
    }
  }

  bool isAlive()
  {
    if (getVie()>0.0) {
      return true;
    }
    
    if (getRevive() > 0)
    {
      setRevive(getRevive()-1);
      giveVie(getComboMax().toDouble());
      return true;
    }

    return false;
  }
  
}
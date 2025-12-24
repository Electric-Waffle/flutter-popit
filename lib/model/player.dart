import 'dart:convert';
import 'package:flutter/foundation.dart';
import './golden_time_uppgrade.dart';
import 'dart:math';

class Player {

  late int _id;

  late double _vie;
  late double _vieBase;

  late int _combo;
  late int _comboMax;

  late int _revive;

  late int _sablier;

  late int _point;

  late Map<String,int> _niveauUppgrades;

  late GoldenTimeUppgrade goldenTimeUppgrade;

  Player(int this._id, double this._vieBase, int this._point, this._niveauUppgrades)
  {
    this._vie = this._vieBase;
    this._combo = 0;
    this._comboMax = 0;
    this._revive = 0;
    this._sablier = 0;
    this.goldenTimeUppgrade = GoldenTimeUppgrade(false, 5, 50);
  }

  @factory
  Player.fromDatabase(int this._id, double this._vieBase, int this._point, niveauUppgradesSerialise)
  {
    this._vie = this._vieBase;
    this._combo = 0;
    this._comboMax = 0;
    setNiveauUppgradesSerialise(niveauUppgradesSerialise);
    this._revive = getLeNiveauDeUneUppgrade("Ankh");
    this._sablier = getLeNiveauDeUneUppgrade("Sablier Fantome");
    this.goldenTimeUppgrade = GoldenTimeUppgrade((getLeNiveauDeUneUppgrade("Penny")>0), 5, 50 - (getLeNiveauDeUneUppgrade("Penny")*2));
  }

  int getRevive ()
  {
    return this._revive;
  }

  int getSablier ()
  {
    return this._sablier;
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

  void setSablier (int sablier)
  {
    this._sablier = sablier;
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
    this._point = point ;
    if (this._point < 0) {
      this._point = 0 ;
    }
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
    int points = 0;
    if (getCombo() > getComboMax()) {
      points = (getCombo()*getLeNiveauDeUneUppgrade("Dernier profit")).toInt();
    }
    else 
    {
      points = (getComboMax()*getLeNiveauDeUneUppgrade("Dernier profit")).toInt();
    }

    points *= getLeNiveauDeUneUppgrade("Cyber-Portefeuille")>0 ? getLeNiveauDeUneUppgrade("Cyber-Portefeuille") * 5 : 1;

    doGivePoints(points);

  }

  void doDamage(double damage)
  {
    double reductionDegat = ((getLeNiveauDeUneUppgrade("Armure") + getLeNiveauDeUneUppgrade("Cyber-Armure")) / 100) * damage;
    double damageFinal = damage - reductionDegat;
    setVie( getVie() - (damageFinal) );
  }

  void doGivePointsSansUppgrades(int points)
  {
    setPoint( getPoint() + points );
  }

  void doGivePoints(int points)
  {

    points += getLeNiveauDeUneUppgrade("Investissement");

    points += getLeNiveauDeUneUppgrade("Cyber-Investissement") * 10;


    if (getVie() > getVieBase()*0.9)
    {
      points += getLeNiveauDeUneUppgrade("Soleil") * (getLeNiveauDeUneUppgrade("Couronne") + 1);
    }

    if (getVie() < getVieBase()*0.1)
    {
      points += getLeNiveauDeUneUppgrade("Ongle de Saphir") > 0 ? getLeNiveauDeUneUppgrade("Lune") * 3 * getLeNiveauDeUneUppgrade("Ongle de Saphir") : getLeNiveauDeUneUppgrade("Lune");
    }

    if (getVieBase()*0.4 < getVie() && getVie() < getVieBase()*0.6)
    {
      points += getLeNiveauDeUneUppgrade("Cyber-Espace")*2;
    }

    if (evenementAleatoire(getLeNiveauDeUneUppgrade("Patte de Lapin").toDouble()))
    {
      points += points;
    }
    else
    {
      if (getLeNiveauDeUneUppgrade("Cyber-Patte de Lapin") > 0 && evenementAleatoire(getLeNiveauDeUneUppgrade("Patte de Lapin").toDouble()))
      {
        points += points;
      }
    }

    if (this.goldenTimeUppgrade.etat == "Utilisation") {
      points += points;
      if (evenementAleatoire(getLeNiveauDeUneUppgrade("Carter")*25)){
        points += points;
      }
    }

    if (evenementAleatoire(getLeNiveauDeUneUppgrade("Bétile de Delphes").toDouble()))
    {
      points += 5 * points;
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

      case "Cyber-Vie":
        setVieBase(getVieBase()+20);
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
  void activeUppgradeAnneauOsiris()
  {
    if (evenementAleatoire(getLeNiveauDeUneUppgrade("Anneau d'Osiris").toDouble()*5)) {
      reduitCooldownGoldenTime(1);
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

  void reduitCooldownGoldenTime(double seconde)
  {
    if (this.goldenTimeUppgrade.etat == "Utilisé" && this.goldenTimeUppgrade.cooldown > 0) {
      this.goldenTimeUppgrade.cooldown -= 1;
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
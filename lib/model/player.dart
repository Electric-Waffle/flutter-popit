
class Player {

  late int _id;

  late double _vie;
  late double _vieBase;

  late int _point;

  late int _niveauShopVie;

  Player(int this._id, double this._vieBase, int this._point, this._niveauShopVie)
  {
    this._vie = this._vieBase;
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

  int getNiveauShopVie()
  {
    return this._niveauShopVie;
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

  void setNiveauShopVie (int unNiveau)
  {
    this._niveauShopVie = unNiveau;
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

  void doUppgradeShop(String uppgrade, int cost)
  {
    doBuyUppgrade(cost);

    switch (uppgrade) {

      case "Vie":

        setNiveauShopVie(getNiveauShopVie()+1);
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
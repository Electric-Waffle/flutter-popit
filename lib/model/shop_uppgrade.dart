
import 'package:flutter/material.dart';

class ShopUppgrade {

  late Color _couleur;

  late String _titre;
  late String _description;

  late int _niveau;
  late int _niveauMax;

  late int _prix;

  ShopUppgrade(this._couleur, this._titre, this._description, this._niveau, this._niveauMax, this._prix);

  Color get couleur => _couleur;

  String get titre => _titre;
  String get description => _description;

  int get niveau => _niveau;
  int get niveauMax => _niveauMax;

  int get prix => _prix;
  
}
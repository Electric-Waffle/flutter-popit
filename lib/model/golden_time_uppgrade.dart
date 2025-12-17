
import 'package:flutter/material.dart';

class GoldenTimeUppgrade {

  // Inexistant Utilisable Utilisation Utilisé
  String _etat = "Inexistant";

  late int _timerMax;
  late int _timer;

  late int _cooldownMax;
  late int _cooldown;

  GoldenTimeUppgrade(bool debloque, this._timerMax, this._cooldownMax)
  {
    this._timer = this._timerMax;
    this._cooldown = this._cooldownMax;
    if (debloque) {
      _etat = "Utilisable";
    }
  }

  String get etat => _etat;
  int get timerMax => _timerMax;
  int get timer => _timer;
  int get cooldownMax => _cooldownMax;
  int get cooldown => _cooldown;

}
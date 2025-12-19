
import 'package:flutter/material.dart';

class GoldenTimeUppgrade {

  // Inexistant Utilisable Utilisation Utilisé
  String etat = "Inexistant";

  late int _timerMax;
  late int timer;

  late int _cooldownMax;
  late int cooldown;

  GoldenTimeUppgrade(bool debloque, this._timerMax, this._cooldownMax)
  {
    this.timer = this._timerMax;
    this.cooldown = this._cooldownMax;
    if (debloque) {
      this.etat = "Utilisable";
    }
  }

  int get timerMax => _timerMax;
  int get cooldownMax => _cooldownMax;

  double getCooldownAdvancement()
  {
    return 1.0 - (this.cooldown / this.cooldownMax).toDouble();
  }


}
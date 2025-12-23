// Import de la bibliothèque pour gérer les temporisateurs (timers).
import 'dart:async';

// Import de la bibliothèque pour générer des nombres aléatoires.
import 'dart:math';

// Import du framework Flutter.
import 'package:flutter/material.dart';
import 'package:popit/shop.dart';
import 'jeu.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Comment Jouer"),
      ),
      body: Text("Work In Progress")
    );
  }
}

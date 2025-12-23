// Import de la bibliothèque pour gérer les temporisateurs (timers).
import 'dart:async';

// Import de la bibliothèque pour générer des nombres aléatoires.
import 'dart:math';

// Import du framework Flutter.
import 'package:flutter/material.dart';
import 'package:popit/shop.dart';
import 'jeu.dart';
import './tutorial.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //backgroundColor: const Color.fromARGB(255, 85, 84, 84),
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Le carré arrondi contenant le titre
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.cyan.shade100,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                "Bloon PopIt",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),

            // Le bouton
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const Uppgrade(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                backgroundColor: Colors.cyan,
              ),
              child: const Text(
                "Jouer",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 25),
            
            // Le bouton
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const Tutorial(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                backgroundColor: const Color.fromARGB(255, 18, 212, 0),
              ),
              child: const Text(
                "Comment jouer",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

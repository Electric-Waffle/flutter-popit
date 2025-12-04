// Import de la bibliothèque pour gérer les temporisateurs (timers).
import 'dart:async';

// Import de la bibliothèque pour générer des nombres aléatoires.
import 'dart:math';

// Import du framework Flutter.
import 'package:flutter/material.dart';
import 'jeu.dart';

class Uppgrade extends StatefulWidget {
  const Uppgrade({super.key});

  @override
  _UppgradeState createState() => _UppgradeState();
}

class _UppgradeState extends State<Uppgrade> {

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text("3 Colonnes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.count(
          crossAxisCount: 3, // 👉 3 colonnes
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            buildRoundedBox(Colors.red, "Rouge"),
            buildRoundedBox(Colors.green, "Vert"),
            buildRoundedBox(Colors.blue, "Bleu"),
            buildRoundedBox(Colors.orange, "Orange"),
            buildRoundedBox(Colors.purple, "Mauve"),
            buildRoundedBox(Colors.yellow, "Jaune"),
            buildRoundedBox(Colors.cyan, "Cyan"),
            buildRoundedBox(Colors.pink, "Rose"),
            buildRoundedBox(Colors.teal, "Teal"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const Jeu(gridSize: 10, cellSize: 40.0),
                  ),
                );},
        tooltip: 'Jouer',
        backgroundColor: Color.fromARGB(255, 200, 200, 200),
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget buildRoundedBox(Color color, String text) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


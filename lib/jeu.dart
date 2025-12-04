// Import de la bibliothèque pour gérer les temporisateurs (timers).
import 'dart:async';

// Import de la bibliothèque pour générer des nombres aléatoires.
import 'dart:math';

// Import du framework Flutter.
import 'package:flutter/material.dart';
import "./model/player.dart";

// Définition d'un StatefulWidget personnalisé pour l'application.
class Jeu extends StatefulWidget {
  // Taille de la grille (nombre de cases en largeur et en hauteur).
  final int gridSize;

  // Taille d'une cellule (en pixels).
  final double cellSize;

  const Jeu({Key? key, required this.gridSize, required this.cellSize})
      : super(key: key);

  @override
  _JeuState createState() => _JeuState();
}

// Classe d'état pour MainApp.
class _JeuState extends State<Jeu> {
  // Liste pour suivre si une bulle doit être affichée pour chaque case.
  late List<bool> isBubbleList;

  // Timer pour déclencher les nouvelles bulles.
  late Timer bubbleChangeTimer;



  @override
  void initState() {
    super.initState();
    // Initialiser la liste des cases en les marquant toutes en rouge.
    isBubbleList =
        List.generate(widget.gridSize * widget.gridSize, (index) => false);

    // Démarrer le timer pour les changements de couleur.
    startBubbleTimer();
  }

  // Méthode pour démarrer le timer des bulles.
  void startBubbleTimer() {
    // Durée d'une seconde pour le timer.
    const duration = Duration(seconds: 1);

    bubbleChangeTimer = Timer.periodic(duration, (Timer timer) {
      // Combien de bulles existent?
      // print(countBubbles());

      setState(() {
        // Générateur de nombres aléatoires.
        final random = Random();

        // Génére un index de case aléatoire pour afficher une bulle.
        final randomIndex = random.nextInt(widget.gridSize * widget.gridSize);

        // On crée une bulle
        isBubbleList[randomIndex] = true;
      });
    });
  }

  int countBubbles() {
    return isBubbleList.where((item) => item == true).length;
  }

  @override
  void dispose() {
    // Arrête le timer lorsque l'application est fermée
    bubbleChangeTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalWidth = widget.gridSize * widget.cellSize;
    final totalHeight = widget.gridSize * widget.cellSize;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(255, 85, 84, 84),
          title: const Text('Bloon PopIt'),
          leading: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pop(context),
            tooltip: "Quitter et retourner au Shop",
          ),
        ),
        body: SizedBox(
          width: totalWidth,
          height: totalHeight,
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(40, 0, 210, 42)),
            child: buildGridView(),
          ),
        
        ),
      ),
    );
  }

  // Widget du plateau de jeu sur 2 dimensions
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: widget.gridSize,
      children: List.generate(widget.gridSize * widget.gridSize, (index) {
        return buildGridItem(index);
      }),
    );
  }

  // Widget d'une case de jeu
  Widget buildGridItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isBubbleList[index] = false;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: isBubbleList[index]
            ? Container(
                key: ValueKey<int>(index * 2 + 1),
                width: widget.cellSize - 2,
                height: widget.cellSize - 2,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bubble.png'),
                    fit: BoxFit.cover,
                  ),
                  color: Color.fromARGB(255, 255, 0, 0),
                ),
              )
            : Container(
                key: ValueKey<int>(index * 2),
                width: widget.cellSize - 2,
                height: widget.cellSize - 2,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(100, 0, 150, 200),
                ),
              ),
      ),
    );
  }
}

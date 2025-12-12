// Import de la bibliothèque pour gérer les temporisateurs (timers).
import 'dart:async';

// Import de la bibliothèque pour générer des nombres aléatoires.
import 'dart:math';

// Import du framework Flutter.
import 'package:flutter/material.dart';
import 'package:popit/model/player_database_helper.dart';
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
class _JeuState extends State<Jeu> with RouteAware {
  // Liste pour suivre si une bulle doit être affichée pour chaque case.
  late List<int> isBubbleList;

  int difficulty = 1;

  // Timer pour déclencher les nouvelles bulles.
  late Timer bubbleChangeTimer = Timer(Duration.zero, () {});

  final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

  int temps = 0;

  Player joueur = PlayerDatabaseHelper().loadData();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // La page redevient visible, on peut relancer le timer
    startBubbleTimer(1000);
  }

  void popBubble(int index)
  {
    if (isBubbleList[index] != 0 && joueur.isAlive()) {
      joueur.doGivePoints(isBubbleList[index]);
      joueur.incrementCombo();
      if (isBubbleList[index] == 1)
      {
        joueur.activeUppgradeFaucheuse();
      }
      setState(() {
        //print("yep $index : ${isBubbleList[index]}");
        isBubbleList[index] = isBubbleList[index]-1;
      });
    }
    else if (isBubbleList[index] == 0 && joueur.isAlive()) {
      joueur.resetCombo();
      setState(() {
        //print("nope $index : ${isBubbleList[index]}");
        joueur.doDamage(1);
      });
    }
  }

  Widget buildBloon(int level) {
    switch (level) {
      case 0:
        return Container(
          key: ValueKey<int>(level * 2),
          width: widget.cellSize - 2,
          height: widget.cellSize - 2,
          margin: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            color: Color.fromARGB(100, 0, 150, 200),
          ),
        );
      case 1:
        return Container(
          key: ValueKey<int>(level * 2 + 1),
          width: widget.cellSize - 2,
          height: widget.cellSize - 2,
          margin: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/BTD6Red.webp'),
              fit: BoxFit.cover,
            ),
            color: Color.fromARGB(255, 255, 0, 0),
          ),
        );
      case 2:
        return Container(
          key: ValueKey<int>(level * 2 + 1),
          width: widget.cellSize - 2,
          height: widget.cellSize - 2,
          margin: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/BTD6Blue.webp'),
              fit: BoxFit.cover,
            ),
            color: Colors.blue,
          ),
        );
      case 3:
        return Container(
          key: ValueKey<int>(level * 2 + 1),
          width: widget.cellSize - 2,
          height: widget.cellSize - 2,
          margin: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/BTD6Green.webp'),
              fit: BoxFit.cover,
            ),
            color: Colors.green,
          ),
        );
      case 4:
        return Container(
          key: ValueKey<int>(level * 2 + 1),
          width: widget.cellSize - 2,
          height: widget.cellSize - 2,
          margin: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/BTD6Yellow.webp'),
              fit: BoxFit.cover,
            ),
            color: Colors.yellow,
          ),
        );
      case 5:
        return Container(
          key: ValueKey<int>(level * 2 + 1),
          width: widget.cellSize - 2,
          height: widget.cellSize - 2,
          margin: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/BTD6Pink.webp'),
              fit: BoxFit.cover,
            ),
            color: Colors.pink,
          ),
        );
      case 6:
        return Container(
          key: ValueKey<int>(level * 2 + 1),
          width: widget.cellSize - 2,
          height: widget.cellSize - 2,
          margin: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/BTD6Black.webp'),
              fit: BoxFit.cover,
            ),
            color: Colors.black,
          ),
        );
      case 7:
        return Container(
          key: ValueKey<int>(level * 2 + 1),
          width: widget.cellSize - 2,
          height: widget.cellSize - 2,
          margin: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/BTD6Zebra.webp'),
              fit: BoxFit.cover,
            ),
            color: Colors.white,
          ),
        );
      default:
        return Container(
          key: ValueKey<int>(level * 2 + 1),
          width: widget.cellSize - 2,
          height: widget.cellSize - 2,
          margin: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/BTD6Rainbow.webp'),
              fit: BoxFit.cover,
            ),
            color: Colors.white,
          ),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialiser la liste des cases en les marquant toutes en rouge.
    isBubbleList =
        List.generate(widget.gridSize * widget.gridSize, (index) => 0);

    // Démarrer le timer pour les changements de couleur.
    startBubbleTimer(1000);
  }

  // Méthode pour démarrer le timer des bulles.
  void startBubbleTimer(int intervalMillisecond) {
  // Annule l'ancien timer s'il existe
    bubbleChangeTimer?.cancel();

    bubbleChangeTimer = Timer.periodic(Duration(milliseconds: intervalMillisecond), (Timer timer) {

      doUppgradeEffectBeforeDamage();

      // Exemple : ton code de génération de bulle
      joueur.doDamage(countBubbles().toDouble());

      setState(() {
        doUppgradeEffectAfterDamage();
        final random = Random();
        final randomIndex = random.nextInt(widget.gridSize * widget.gridSize);
        isBubbleList[randomIndex] = random.nextInt(difficulty) + 1;
        temps += 1;

        // Changement de durée
        switch (temps) {

          case 10:
            startBubbleTimer(900); 
            break;

          case 30:
            startBubbleTimer(800);
            difficulty = 2;
            break;

          case 70:
            startBubbleTimer(700); 
            difficulty = 3;
            break;

          case 160:
            startBubbleTimer(600);
            difficulty = 4;
            break;

          case 360:
            startBubbleTimer(500); 
            difficulty = 5;
            break;

          case 460:
            startBubbleTimer(450); 
            difficulty = 6;
            break;

          case 560:
            startBubbleTimer(400);
            difficulty = 7;
            break;

          case 660:
            startBubbleTimer(350); 
            break;

          case 860:
            startBubbleTimer(300); 
            break;

          default:
        }
        if (temps == 5) {
        } else if (temps == 20) {
          startBubbleTimer(500); // idem
        }

        int ankh = joueur.getRevive();
        if (!joueur.isAlive()) {
          joueur.setVie(0);
          if (joueur.getLeNiveauDeUneUppgrade("Dernier profit") > 0) {
            joueur.cashoutCombo();
          }
          if (joueur.getLeNiveauDeUneUppgrade("Supernova") > 0)
          {
            supernova();
          }
          bubbleChangeTimer?.cancel();
        }
        if (ankh!= joueur.getRevive() && joueur.getLeNiveauDeUneUppgrade("Supernova") > 0)
        {
          supernova();
        }
      });
    });
  }

  supernova()
  {
    joueur.doGivePoints(countSumBubbles() * 3);

    isBubbleList =
        List.generate(widget.gridSize * widget.gridSize, (index) => 0);
    
  }

  int countSumBubbles() {
    return isBubbleList.fold(0, (acc, item) => (((item * (item+1)) / 2).toInt()) + acc);
  }

  void doUppgradeEffectBeforeDamage() {
  }

  void doUppgradeEffectAfterDamage() {

    // Regénération
    joueur.giveVie(joueur.getLeNiveauDeUneUppgrade("Regénération")*0.1);
    
  }

  int countBubbles() {
    return isBubbleList.fold(0, (acc, item) => acc + item);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    // Arrête le timer lorsque l'application est fermée
    bubbleChangeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalWidth = widget.gridSize * widget.cellSize;
    final totalHeight = widget.gridSize * widget.cellSize;
    final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      navigatorObservers: [routeObserver],

      debugShowCheckedModeBanner: false,
      
      home: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(255, 85, 84, 84),

          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(joueur.getVie().toStringAsFixed(1)),
              const Icon(Icons.favorite),
              Container(
                width: 50,
              ),
              Text(joueur.getPoint().toString()),
              const Icon(Icons.bubble_chart),
              Container(
                width: 50,
              ),
              if (joueur.getLeNiveauDeUneUppgrade("Dernier profit") > 0) ...{
                Text("${joueur.getCombo().toString()} / ${joueur.getComboMax().toString()}"),
                const Icon(Icons.whatshot),
                Container(
                  width: 50,
                ),
              },
              if (joueur.getRevive() > 0) ...{
                const Icon(Icons.add_location),
                Container(
                  width: 50,
                ),
              }
            ],
          ),
          
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: ()  {
                  PlayerDatabaseHelper().saveData(joueur);
                  Navigator.pop(context, true);
                },
                tooltip: "Quitter et retourner au Shop",
              ),

            ],
          )
          

        ),
        body: SizedBox(
          width: totalWidth,
          height: totalHeight,
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(40, 0, 210, 42)),
            child: joueur.isAlive() ? buildGridView() :  
              Container(
                height: screenHeight * 0.3, // 30% de la hauteur de l'écran
                width: double.infinity, // prend toute la largeur disponible
                color: Colors.blueAccent, // juste pour voir le container
                child: const Center(
                  child: Text(
                    "Game Over",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
          ),
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
      onTap: () => { popBubble(index) },
      child: buildBloon(isBubbleList[index]) 
    );
  }
}

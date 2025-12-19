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

  final aleatoire = Random();

  bool timeStop = false ;

  int difficulty = 1;

  bool joueurCharge = false;

  // Timer pour déclencher les nouvelles bulles.
  late Timer bubbleChangeTimer = Timer(Duration.zero, () {});

  late Timer hourglassStopTimer = Timer(Duration.zero, () {});

  late Timer oneSecondTimer = Timer(Duration.zero, () {});

  final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

  int temps = 0;

  PlayerDatabaseHelper sauvegarde = PlayerDatabaseHelper();
  late Player joueur;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // La page redevient visible, on peut relancer le timer
    startBubbleTimer(1000);
    startOneSecondTimer(1000);
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
      
      if (joueur.goldenTimeUppgrade.etat != "Utilisation") {
        setState(() {
          isBubbleList[index] = isBubbleList[index]-1;
        });
      }
    }
    else if (isBubbleList[index] == 0 && joueur.isAlive()) {
      if (joueur.evenementAleatoire(100 - (joueur.getLeNiveauDeUneUppgrade("Chance Liquide")*10)))
      {
        joueur.resetCombo();
        setState(() {
          joueur.doDamage(1);
        });
      }
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

    // Récupérer le joueur
    initJoueur();

    // Démarrer le timer pour les changements de couleur.
    startBubbleTimer(1000);
    startOneSecondTimer(1000);

    // lancer l'affichage
  }

  void initJoueur() async
  {
    await this.sauvegarde.openDatabase();
    this.joueur = await this.sauvegarde.loadData();
    setState(() {this.joueurCharge = true;}); // pour que l'UI se mette à jour avec le joueur chargé
  }

  // Méthode pour démarrer le timer des bulles.
  void startBubbleTimer(int intervalMillisecond) {
  // Annule l'ancien timer s'il existe
    bubbleChangeTimer?.cancel();

    bubbleChangeTimer = Timer.periodic(Duration(milliseconds: intervalMillisecond), (Timer timer) {

      if (this.timeStop == false)
      {
        doUppgradeEffectBeforeDamage();

        // Exemple : ton code de génération de bulle
        joueur.doDamage(countBubbles().toDouble());

        // Vérifie si le widget est toujours monté avant d'appeler setState
        if (mounted) {
          setState(() {
            doUppgradeEffectAfterDamage();
            final random = Random();

            if (joueur.goldenTimeUppgrade.etat != "Utilisation") {
              final randomIndex = random.nextInt(widget.gridSize * widget.gridSize);
              isBubbleList[randomIndex] = random.nextInt(difficulty) + 1;
            }
            
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
    
              joueur.doGivePointsSansUppgrades(joueur.getLeNiveauDeUneUppgrade("Argent de poche")*10);
              joueur.doGivePointsSansUppgrades(joueur.getLeNiveauDeUneUppgrade("Vide Grenier")*100);
              joueur.doGivePointsSansUppgrades(joueur.getLeNiveauDeUneUppgrade("Pension de Retraite")*250);
              joueur.doGivePointsSansUppgrades(joueur.getLeNiveauDeUneUppgrade("Cyber-Bitcoin")*(aleatoire.nextInt(1000) + 500));

              bubbleChangeTimer?.cancel();
            }
            if (ankh != joueur.getRevive() && joueur.getLeNiveauDeUneUppgrade("Supernova") > 0)
            {
              supernova();
            }
          });
        }
      }
      
    });
  }

  void doGoldenTime()
  {
    joueur.goldenTimeUppgrade.etat = "Utilisation";
  }

  // Méthode pour démarrer le timer des secondes.
  void startOneSecondTimer(int intervalMillisecond) {
  // Annule l'ancien timer s'il existe
    oneSecondTimer?.cancel();

    oneSecondTimer = Timer.periodic(Duration(milliseconds: intervalMillisecond), (Timer timer) {

      // Vérifie si le widget est toujours monté avant d'appeler setState
      if (mounted) {
        setState(() {

          if (joueur.goldenTimeUppgrade.etat == "Utilisation" && joueur.goldenTimeUppgrade.timer > 0) {
            joueur.goldenTimeUppgrade.timer -= 1;
          }
          else if (joueur.goldenTimeUppgrade.etat == "Utilisation" && joueur.goldenTimeUppgrade.timer == 0) {
            joueur.goldenTimeUppgrade.timer = joueur.goldenTimeUppgrade.timerMax;
            joueur.goldenTimeUppgrade.etat = "Utilisé";
          }

          if (joueur.goldenTimeUppgrade.etat == "Utilisé" && joueur.goldenTimeUppgrade.cooldown > 0) {
            joueur.goldenTimeUppgrade.cooldown -= 1;
          }
          else if (joueur.goldenTimeUppgrade.etat == "Utilisé" && joueur.goldenTimeUppgrade.cooldown == 0) {
            joueur.goldenTimeUppgrade.cooldown = joueur.goldenTimeUppgrade.cooldownMax;
            joueur.goldenTimeUppgrade.etat = "Utilisable";
          }

        });
      }
      
    });
  }

  // Méthode pour démarrer le timer du stop du sablier.
  void stopTimeWithHourglass() {
  // Annule l'ancien timer s'il existe
    setState(() {
      joueur.setSablier(joueur.getSablier()-1);
      this.timeStop = true;
    });

    
    int tempsStop = 0;

    hourglassStopTimer = Timer.periodic(const Duration(milliseconds: 1000), (Timer timer) {

      doUppgradeEffectBeforeDamage();

      setState(() {
        doUppgradeEffectAfterDamage();

        tempsStop += 1;

        if (tempsStop == 4) {
          this.timeStop = false;
          hourglassStopTimer?.cancel();
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

    // Cyber-Regénération
    joueur.giveVie(joueur.getLeNiveauDeUneUppgrade("Cyber-Regénération")*0.5);

    // Dividendes
    joueur.doGivePointsSansUppgrades(joueur.getLeNiveauDeUneUppgrade("Dividendes"));

    // Cyber-Dividendes
    joueur.doGivePointsSansUppgrades(joueur.getLeNiveauDeUneUppgrade("Cyber-Dividendes")*10);
    
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

    if (!this.joueurCharge) {
      return const Center(child: CircularProgressIndicator());
    }

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
              const SizedBox(width: 50),

              Text(joueur.getPoint().toString()),
              const Icon(Icons.bubble_chart),
              const SizedBox(width: 50),

              if (joueur.getLeNiveauDeUneUppgrade("Dernier profit") > 0) ...[
                Text("${joueur.getCombo()} / ${joueur.getComboMax()}"),
                const Icon(Icons.whatshot),
                const SizedBox(width: 50),
              ],

              if (joueur.getRevive() > 0) ...[
                const Icon(Icons.add_location),
                const SizedBox(width: 50),
              ],

              if (joueur.goldenTimeUppgrade.etat != "Inexistant") ...[
                if (joueur.goldenTimeUppgrade.etat == "Utilisable") 
                  ElevatedButton.icon(
                    onPressed: () => doGoldenTime(),
                    label: const Icon(Icons.attach_money),
                  ),

                if (joueur.goldenTimeUppgrade.etat == "Utilisation") 
                  ElevatedButton.icon(
                    onPressed: null,
                    label: const Icon(Icons.currency_exchange),
                  ),

                if (joueur.goldenTimeUppgrade.etat == "Utilisé") 
                  ElevatedButton.icon(
                    onPressed: null,
                    label: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.money_off),
                        CircularProgressIndicator(
                          value: (joueur.goldenTimeUppgrade.getCooldownAdvancement()),
                        )
                      ],
                    ),
                  ),
                const SizedBox(width: 50),
              ],

              if (joueur.getLeNiveauDeUneUppgrade("Sablier Fantome") > 0 &&
                  joueur.getSablier() > 0 &&
                  timeStop == false) ...[
                ElevatedButton.icon(
                  onPressed: () => stopTimeWithHourglass(),
                  icon: const Icon(Icons.hourglass_empty),
                  label: Text(joueur.getSablier().toString()),
                ),
                const SizedBox(width: 50),
              ]
              else if (joueur.getLeNiveauDeUneUppgrade("Sablier Fantome") > 0 &&
                  joueur.getSablier() > 0 &&
                  timeStop == true) ...[
                ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.hourglass_full),
                  label: Text(joueur.getSablier().toString()),
                ),
                const SizedBox(width: 50),
              ]
              else if (joueur.getLeNiveauDeUneUppgrade("Sablier Fantome") > 0 &&
                  joueur.getSablier() == 0) ...[
                const ElevatedButton(
                  onPressed: null,
                  child: Icon(Icons.hourglass_disabled),
                ),
                const SizedBox(width: 50),
              ],
            ],
          ),

          
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: ()  {
                  sauvegarde.saveData(joueur);
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

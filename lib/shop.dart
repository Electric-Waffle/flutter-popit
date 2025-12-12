// Import de la bibliothèque pour gérer les temporisateurs (timers).
import 'dart:async';

// Import de la bibliothèque pour générer des nombres aléatoires.
import 'dart:math';

// Import du framework Flutter.
import 'package:flutter/material.dart';
import 'jeu.dart';
import './model/player_database_helper.dart';
import './model/player.dart';
import './model/shop_uppgrade.dart';

class Uppgrade extends StatefulWidget {
  const Uppgrade({super.key});

  @override
  _UppgradeState createState() => _UppgradeState();
}

class _UppgradeState extends State<Uppgrade> {

  PlayerDatabaseHelper sauvegarde = PlayerDatabaseHelper();
  late Player joueur;
  late List<ShopUppgrade> uppgrades;

  @override
  void initState() {
    super.initState();
    this.joueur = sauvegarde.loadData();
    recreeListeUppgrades();
  }

  void recreeListeUppgrades()
  {

    this.uppgrades = [
      ShopUppgrade(Colors.red, "Vie", "Gagne 10 points de vie par niveau", recupereNiveauUppgradeDuJoueurOuLeCree("Vie"), 5, getPrixFromNiveauJoueur([10, 20, 30, 40, 50], joueur.getLeNiveauDeUneUppgrade("Vie"))),
      ShopUppgrade(Colors.pink, "Regénération", "Regenere 0.1 points de vie/seconde par niveau", recupereNiveauUppgradeDuJoueurOuLeCree("Regénération"), 10, getPrixFromNiveauJoueur([25, 45, 65, 85, 105, 125, 145, 165, 185, 205], joueur.getLeNiveauDeUneUppgrade("Regénération"))),
      ShopUppgrade(Colors.blueGrey, "Armure", "Réduit les dégats reçus de 1% par niveau", recupereNiveauUppgradeDuJoueurOuLeCree("Armure"), 10, getPrixFromNiveauJoueur([50, 75, 100, 150, 175, 200, 250, 275, 300, 500], joueur.getLeNiveauDeUneUppgrade("Armure"))),
      ShopUppgrade(Colors.yellow.shade900, "Patte de Lapin", "Augmente de 1% les chances de doubler les gains d'un clic", recupereNiveauUppgradeDuJoueurOuLeCree("Patte de Lapin"), 25, getPrixFromNiveauJoueur([100, 125, 150, 175, 200, 225, 250, 275, 300, 325, 350, 375, 400, 425, 450, 475, 500, 525, 550, 575, 600, 625, 650, 675, 700], joueur.getLeNiveauDeUneUppgrade("Patte de Lapin"))),
      ShopUppgrade(Colors.cyan.shade900, "Investissement", "Augmente les gains d'un clic de 1", recupereNiveauUppgradeDuJoueurOuLeCree("Investissement"), 1, getPrixFromNiveauJoueur([500], joueur.getLeNiveauDeUneUppgrade("Investissement"))),
      ShopUppgrade(Colors.indigo.shade900, "Destockage", "Récupère de nouvelles améliorations pour le shop", recupereNiveauUppgradeDuJoueurOuLeCree("Destockage"), 1, getPrixFromNiveauJoueur([1000], joueur.getLeNiveauDeUneUppgrade("Destockage"))),
    ];

    if (joueur.getLeNiveauDeUneUppgrade("Destockage") > 0)
    {
      this.uppgrades.addAll(
        [
          ShopUppgrade(Colors.lightGreen.shade900, "Dernier profit", "Débloque le combot. A la fin d'une partie, gagne comboMax*niveau bloon.", recupereNiveauUppgradeDuJoueurOuLeCree("Dernier profit"), 3, getPrixFromNiveauJoueur([1000, 2500, 5000], joueur.getLeNiveauDeUneUppgrade("Dernier profit"))),
          ShopUppgrade(Colors.redAccent.shade700, "Faucheuse", "Augmente de 2%/niveau les chances de soigner 1 point de vie en éclatant un ballon rouge", recupereNiveauUppgradeDuJoueurOuLeCree("Faucheuse"), 5, getPrixFromNiveauJoueur([500, 1000, 1500, 2000, 2500], joueur.getLeNiveauDeUneUppgrade("Faucheuse"))),
          ShopUppgrade(Colors.deepOrange.shade900, "Soleil", "Quand vie>90%, les gains de clic sont augmentés de 1/niveau", recupereNiveauUppgradeDuJoueurOuLeCree("Soleil"), 5, getPrixFromNiveauJoueur([300, 900, 1200, 1500, 2000], joueur.getLeNiveauDeUneUppgrade("Soleil"))),
          ShopUppgrade(const Color.fromARGB(255, 225, 169, 0), "Ankh", "Quand la vie arrive a zéro, une seule fois, regagne des pv égaux au comboMax", recupereNiveauUppgradeDuJoueurOuLeCree("Ankh"), 1, getPrixFromNiveauJoueur([5000], joueur.getLeNiveauDeUneUppgrade("Ankh"))),
          ShopUppgrade(Colors.lightBlue.shade900, "Supernova", "Quand la vie arrive a zéro, élimine tout les bloons sur le terrain et donne 3 fois leur valeur basique", recupereNiveauUppgradeDuJoueurOuLeCree("Supernova"), 1, getPrixFromNiveauJoueur([2500], joueur.getLeNiveauDeUneUppgrade("Supernova"))),
          ShopUppgrade(Colors.indigo.shade900, "Tombée de Camion", "\"\"Récupère\"\" de nouvelles améliorations pour le shop", recupereNiveauUppgradeDuJoueurOuLeCree("Tombée de Camion"), 1, getPrixFromNiveauJoueur([20000], joueur.getLeNiveauDeUneUppgrade("Tombée de Camion"))),
        ]
      );
    }

    if (joueur.getLeNiveauDeUneUppgrade("Tombée de Camion") > 0)
    {
      this.uppgrades.addAll(
        [
          ShopUppgrade(Colors.indigoAccent.shade700, "Lune", "Quand vie<10%, les gains de clic sont augmentés de 2/niveau", recupereNiveauUppgradeDuJoueurOuLeCree("Lune"), 5, getPrixFromNiveauJoueur([300, 900, 1200, 1500, 2000], joueur.getLeNiveauDeUneUppgrade("Lune"))),
        ]
      );
    }
  }     

  int getPrixFromNiveauJoueur(List<int> paliers, int niveau)
  {
    if (niveau >= paliers.length)
    {
      return 0;
    }
    return paliers[niveau];
  }

  int recupereNiveauUppgradeDuJoueurOuLeCree(String uppgrade)
  {
    // si l'uppgrade en question n'existe pas dans le joueur , on la cree et on la sauvegarde
    if (!joueur.isUppgradeDansJoueur(uppgrade))
    {
      joueur.setLeNiveauDeUneUppgrade(uppgrade, 0);
      sauvegarde.saveData(joueur);
    }

    return joueur.getLeNiveauDeUneUppgrade(uppgrade);
  }

  void acheteUppgrade(ShopUppgrade uppgradeAAcheter){
    if (joueur.getPoint() >= uppgradeAAcheter.prix) {
      setState(() {

        joueur.doUppgradeShop(uppgradeAAcheter.titre ,uppgradeAAcheter.prix);
        sauvegarde.saveData(joueur);

        recreeListeUppgrades();

      });
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        actions: [
          Text(joueur.getVieBase().toString()),
              const Icon(Icons.favorite),
              Container(
                width: 50,
              ),
              Text(joueur.getPoint().toString()),
              const Icon(Icons.bubble_chart),
              Container(
                width: 50,
              ),
        ],
      ),


      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: 
          GridView.builder(

            gridDelegate:  
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
              ),

            itemCount: uppgrades.length,
            
            itemBuilder: (context, index) {
              return buildRoundedBox(uppgrades[index]);
            },
          )
        ),


      floatingActionButton: FloatingActionButton(
        onPressed: ()  
          async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                    builder: (context) =>
                        const Jeu(gridSize: 10, cellSize: 40.0),
                  ),
            );

            if (result == true) {
              setState(() {
                joueur.reloadPlayer(sauvegarde.loadData());
              });
            }
          },
        tooltip: 'Jouer',
        backgroundColor: Color.fromARGB(255, 200, 200, 200),
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget buildRoundedBox(ShopUppgrade uppgrade ) {
    return Container(
      decoration: BoxDecoration(
        color: uppgrade.couleur.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Text(
                  uppgrade.titre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
          ),
            Center(
              child: Text(
                    uppgrade.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
            ),
          if (uppgrade.niveau < uppgrade.niveauMax ) ...{
            Center(
              child: Text(
                    "Niveau : ${uppgrade.niveau}/${uppgrade.niveauMax}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
            ),
          },
          if (joueur.getPoint() >= uppgrade.prix && uppgrade.niveau < uppgrade.niveauMax ) ...{
                Center(
                  child: ElevatedButton(onPressed:() => acheteUppgrade(uppgrade), child: const Text("Acheter")),
                ),
          }
          else if (uppgrade.niveau >= uppgrade.niveauMax ) ...{
                const Center(
                  child: ElevatedButton(onPressed: null, child: Text("MAX")),
                ),
          }
          else ...{
            const Center(
                  child: ElevatedButton(onPressed: null, child: Text("X")),
                ),
          },
          if (uppgrade.niveau < uppgrade.niveauMax ) ...{
            Center(
              child: Text(
                    "Prix : ${uppgrade.prix} Bloons",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
            ),
          },
        ],
      )
      
    );
  }
}


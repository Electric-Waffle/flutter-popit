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
      ShopUppgrade(Colors.red, "Vie", "Gagne 10 points de vie par niveau", joueur.getLeNiveauDeUneUppgrade("Vie"), 5, 15*joueur.getLeNiveauDeUneUppgrade("Vie")),
    ];
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


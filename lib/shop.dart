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
      ShopUppgrade(Colors.yellow.shade900, "Patte de Lapin", "Augmente de 1% les chances de doubler les gains d'un clic", recupereNiveauUppgradeDuJoueurOuLeCree("Patte de Lapin"), 25, getPrixFromNiveauJoueur([100, 125, 150, 175, 200, 2250, 2500, 2750, 3000, 32500, 35000, 37500, 40000, 42500, 45000, 47500, 50000, 52500, 55000, 57500, 60000, 62500, 65000, 67500, 70000], joueur.getLeNiveauDeUneUppgrade("Patte de Lapin"))),
      ShopUppgrade(Colors.brown.shade900, "Dividendes", "Gagne 1*niveau bloon a chaque génération de bloon", recupereNiveauUppgradeDuJoueurOuLeCree("Dividendes"), 5, getPrixFromNiveauJoueur([150, 175, 200, 225, 250], joueur.getLeNiveauDeUneUppgrade("Dividendes"))),
      ShopUppgrade(Colors.cyan.shade900, "Investissement", "Augmente les gains d'un clic de 1", recupereNiveauUppgradeDuJoueurOuLeCree("Investissement"), 1, getPrixFromNiveauJoueur([500], joueur.getLeNiveauDeUneUppgrade("Investissement"))),
      ShopUppgrade(Colors.indigo.shade900, "Destockage", "Récupère de nouvelles améliorations pour le shop chez un antiquaire", recupereNiveauUppgradeDuJoueurOuLeCree("Destockage"), 1, getPrixFromNiveauJoueur([1000], joueur.getLeNiveauDeUneUppgrade("Destockage"))),
    ];

    if (joueur.getLeNiveauDeUneUppgrade("Destockage") > 0)
    {
      this.uppgrades.addAll(
        [
          ShopUppgrade(Colors.cyan.shade900, "Penny", "Un doublon Rouge qui arrete la génération de bloon, les rend increvable, et double les gains. Cooldown : 50 - 2*niveau secondes.", recupereNiveauUppgradeDuJoueurOuLeCree("Investissement"), 10, getPrixFromNiveauJoueur([500, 1000, 5000, 10000, 50000, 100000, 200000, 300000, 500000, 1000000], joueur.getLeNiveauDeUneUppgrade("Investissement"))),
          ShopUppgrade(Colors.lightGreen.shade900, "Dernier profit", "Un portefeuille qui débloque le combot. A la fin d'une partie, gagne comboMax*niveau bloon.", recupereNiveauUppgradeDuJoueurOuLeCree("Dernier profit"), 3, getPrixFromNiveauJoueur([1000, 2500, 5000], joueur.getLeNiveauDeUneUppgrade("Dernier profit"))),
          ShopUppgrade(Colors.deepOrange.shade900, "Soleil", "Un joli collier. Quand vie>90%, les gains de clic sont augmentés de 1/niveau", recupereNiveauUppgradeDuJoueurOuLeCree("Soleil"), 5, getPrixFromNiveauJoueur([300, 900, 1200, 1500, 2000], joueur.getLeNiveauDeUneUppgrade("Soleil"))),
          ShopUppgrade(Colors.indigoAccent.shade700, "Lune", "Un magnifique bracelet. Quand vie<10%, les gains de clic sont augmentés de 3/niveau", recupereNiveauUppgradeDuJoueurOuLeCree("Lune"), 5, getPrixFromNiveauJoueur([300, 900, 1200, 1500, 2000], joueur.getLeNiveauDeUneUppgrade("Lune"))),
          ShopUppgrade(Colors.redAccent.shade700, "Faucheuse", "Une faucille qui augmente de 2%/niveau les chances de soigner 1 point de vie en éclatant un ballon rouge", recupereNiveauUppgradeDuJoueurOuLeCree("Faucheuse"), 5, getPrixFromNiveauJoueur([500, 1000, 1500, 2000, 2500], joueur.getLeNiveauDeUneUppgrade("Faucheuse"))),
          ShopUppgrade(const Color.fromARGB(255, 225, 169, 0), "Ankh", "Un artefact précieux. Quand la vie arrive a zéro, une seule fois, regagne des pv égaux au comboMax", recupereNiveauUppgradeDuJoueurOuLeCree("Ankh"), 1, getPrixFromNiveauJoueur([5000], joueur.getLeNiveauDeUneUppgrade("Ankh"))),
          ShopUppgrade(Colors.indigo.shade900, "Tombée de Camion", "\"\"Récupère\"\" de nouvelles améliorations pour le shop dans le camion de déménagement d'Indiana Jones.", recupereNiveauUppgradeDuJoueurOuLeCree("Tombée de Camion"), 1, getPrixFromNiveauJoueur([20000], joueur.getLeNiveauDeUneUppgrade("Tombée de Camion"))),
        ]
      );
    }

    if (joueur.getLeNiveauDeUneUppgrade("Tombée de Camion") > 0)
    {
      this.uppgrades.addAll(
        [
          ShopUppgrade(Colors.lightBlue.shade900, "Supernova", "Une gemme instable. Quand la vie arrive a zéro, élimine tout les bloons sur le terrain et donne 3 fois leur valeur basique", recupereNiveauUppgradeDuJoueurOuLeCree("Supernova"), 1, getPrixFromNiveauJoueur([9000], joueur.getLeNiveauDeUneUppgrade("Supernova"))),
          ShopUppgrade(Colors.lime.shade900, "Sablier Fantome", "Quand on clique sur l'icone, le temps arrête pendant 3 secondes. Utilisable 1*niveau par partie.", recupereNiveauUppgradeDuJoueurOuLeCree("Sablier Fantome"), 7, getPrixFromNiveauJoueur([13000, 15000, 17000, 19000, 21000, 23000, 25000], joueur.getLeNiveauDeUneUppgrade("Sablier Fantome"))),
          ShopUppgrade(Colors.indigo.shade900, "Entente Illicite", "Monopolise le cyber-marché avec un concurrent pour récupérer de nouvelles cyber-améliorations", recupereNiveauUppgradeDuJoueurOuLeCree("Entente Illicite"), 1, getPrixFromNiveauJoueur([50000], joueur.getLeNiveauDeUneUppgrade("Entente Illicite"))),
        ]
      );
    }

    if (joueur.getLeNiveauDeUneUppgrade("Entente Illicite") > 0)
    {
      this.uppgrades.addAll(
        [
          ShopUppgrade(Colors.red, "Cyber-Vie", "Gagne 20 points de vie par niveau", recupereNiveauUppgradeDuJoueurOuLeCree("Cyber-Vie"), 5, getPrixFromNiveauJoueur([10000, 20000, 30000, 40000, 50000], joueur.getLeNiveauDeUneUppgrade("Cyber-Vie"))),
          ShopUppgrade(Colors.pink, "Cyber-Regénération", "Regenere 0.5 points de vie/seconde supplémentaire par niveau", recupereNiveauUppgradeDuJoueurOuLeCree("Cyber-Regénération"), 10, getPrixFromNiveauJoueur([30000, 35000, 40000, 45000, 50000, 55000, 60000, 65000, 70000, 75000], joueur.getLeNiveauDeUneUppgrade("Cyber-Regénération"))),
          ShopUppgrade(Colors.blueGrey, "Cyber-Armure", "Réduit les dégats reçus de 1% supplémentaire par niveau", recupereNiveauUppgradeDuJoueurOuLeCree("Cyber-Armure"), 10, getPrixFromNiveauJoueur([40000, 42000, 44000, 46000, 48000, 50000, 52000, 54000, 56000, 58000], joueur.getLeNiveauDeUneUppgrade("Cyber-Armure"))),
          ShopUppgrade(Colors.yellow.shade900, "Cyber-Patte de Lapin", "Si le gain de clic n'est pas doublé, réessaye de le doubler.", recupereNiveauUppgradeDuJoueurOuLeCree("Cyber-Patte de Lapin"), 1, getPrixFromNiveauJoueur([150000], joueur.getLeNiveauDeUneUppgrade("Cyber-Patte de Lapin"))),
          ShopUppgrade(Colors.brown.shade900, "Cyber-Dividendes", "Gagne 5*niveau bloon a chaque génération de bloon", recupereNiveauUppgradeDuJoueurOuLeCree("Dividendes"), 5, getPrixFromNiveauJoueur([60000, 70000, 80000, 90000, 100000], joueur.getLeNiveauDeUneUppgrade("Dividendes"))),
          ShopUppgrade(Colors.cyan.shade900, "Cyber-Investissement", "Augmente les gains d'un clic de 10", recupereNiveauUppgradeDuJoueurOuLeCree("Cyber-Investissement"), 1, getPrixFromNiveauJoueur([100000], joueur.getLeNiveauDeUneUppgrade("Cyber-Investissement"))),
          ShopUppgrade(Colors.indigoAccent.shade700, "Cyber-Espace", "L'ultime Cyber. Quand 40%<vie<60%, les gains de clic sont augmentés de 2/niveau", recupereNiveauUppgradeDuJoueurOuLeCree("Cyber-Espace"), 5, getPrixFromNiveauJoueur([100000, 125000, 150000, 175000, 200000], joueur.getLeNiveauDeUneUppgrade("Cyber-Espace"))),
          ShopUppgrade(Colors.indigo.shade900, "Cyber-Braquage", "Mettez vos cyber-compétences a profit de la meilleure cause (la votre) en braquant une brasserie.", recupereNiveauUppgradeDuJoueurOuLeCree("Cyber-Braquage"), 1, getPrixFromNiveauJoueur([250000], joueur.getLeNiveauDeUneUppgrade("Cyber-Braquage"))),
        ]
      );
    }

    if (joueur.getLeNiveauDeUneUppgrade("Cyber-Braquage") > 0)
    {
      this.uppgrades.addAll(
        [
          ShopUppgrade(const Color.fromARGB(255, 225, 169, 0), "Chance Liquide", "Bière Trappiste. 10*niveau% de chance de ne pas reset le comboMax en touchant un carré vide.", recupereNiveauUppgradeDuJoueurOuLeCree("Chance Liquide"), 5, getPrixFromNiveauJoueur([300000, 350000, 400000, 450000, 500000], joueur.getLeNiveauDeUneUppgrade("Chance Liquide"))),
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


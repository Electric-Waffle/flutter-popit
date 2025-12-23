// Import de la bibliothèque pour gérer les temporisateurs (timers).
import 'dart:async';
import 'dart:developer' as developer;

// Import de la bibliothèque pour générer des nombres aléatoires.
import 'dart:math';
import 'dart:ui';

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
  final ScrollController _scrollController = ScrollController();
  PlayerDatabaseHelper sauvegarde = PlayerDatabaseHelper();
  bool isInCharacterMenu = false;
  late Player joueur;
  late List<ShopUppgrade> uppgrades;
  bool joueurCharge = false;
  List<String> listeStats = [];
  List<String> listeDeUppgrades = [
    "Vie",
    "Regénération",
    "Armure",
    "Patte de Lapin",
    "Dividendes",
    "Investissement",
    "Argent de poche",
    "Destockage",
    "Penny",
    "Dernier profit",
    "Soleil",
    "Lune",
    "Faucheuse",
    "Ankh",
    "Vide Grenier",
    "Tombée de Camion",
    "Carter",
    "Couronne",
    "Supernova",
    "Sablier Fantome",
    "Bétile de Delphes",
    "Pension de Retraite",
    "Entente Illicite",
    "Cyber-Vie",
    "Cyber-Regénération",
    "Cyber-Armure",
    "Cyber-Patte de Lapin",
    "Cyber-Dividendes",
    "Cyber-Investissement",
    "Cyber-Espace",
    "Cyber-Bitcoin",
    "Cyber-Braquage",
    "Chance Liquide",
    "Ongle de Saphir",
    "Lampe Magique",
    "Pack de developpeur",
    "Anneau d'Osiris"
  ];

  @override
  void initState() {
    super.initState();
    initJoueur();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void initJoueur() async {
    await sauvegarde.openDatabase();
    this.joueur = await sauvegarde.loadData();
    await creeNiveauUppgradeSiExistePas();
    recreeListeUppgrades(); // <- ici, après que joueur est prêt
    setState(() {
      this.joueurCharge = true;
    }); // pour que l'UI se mette à jour avec le joueur chargé
    initListeStats();
  }

  void initListeStats()
  {
    this.listeStats = [
      "Points de vie : ${joueur.getVie()}",
      "Regénération : ${joueur.getLeNiveauDeUneUppgrade("Regénération")*0.1 + joueur.getLeNiveauDeUneUppgrade("Cyber-Regénération")*0.5} points de vie/seconde",
      "Réduction des dégâts : ${joueur.getLeNiveauDeUneUppgrade("Armure")*1 + joueur.getLeNiveauDeUneUppgrade("Cyber-Armure")*1}%",
      "Chance de doubler les gains d'un clic : ${joueur.getLeNiveauDeUneUppgrade("Patte de Lapin")*1}%",

    ];
  }

  void recreeListeUppgrades() {
    this.uppgrades = [
      ShopUppgrade(
          Colors.black,
          "Pack de developpeur",
          "Gagne un milion de bloons. Comme ca.",
          joueur.getLeNiveauDeUneUppgrade("Pack de developpeur"),
          1,
          [1]),

      ShopUppgrade(
          Colors.red,
          "Vie",
          "Gagne 10 points de vie par niveau",
          joueur.getLeNiveauDeUneUppgrade("Vie"),
          5,
          [10, 20, 30, 40, 50]),

      ShopUppgrade(
          Colors.pink,
          "Regénération",
          "Regenere 0.1 points de vie/seconde par niveau",
          joueur.getLeNiveauDeUneUppgrade("Regénération"),
          10,
          [25, 45, 65, 85, 105, 125, 145, 165, 185, 205]),

      ShopUppgrade(
          Colors.blueGrey,
          "Armure",
          "Réduit les dégats reçus de 1% par niveau",
          joueur.getLeNiveauDeUneUppgrade("Armure"),
          10,
          [50, 75, 100, 150, 175, 200, 250, 275, 300, 500]),

      ShopUppgrade(
          Colors.yellow.shade900,
          "Patte de Lapin",
          "Augmente de 1% les chances de doubler les gains d'un clic",
          joueur.getLeNiveauDeUneUppgrade("Patte de Lapin"),
          25,
          [
            100,
            125,
            150,
            175,
            200,
            2250,
            2500,
            2750,
            3000,
            32500,
            35000,
            37500,
            40000,
            42500,
            45000,
            47500,
            50000,
            52500,
            55000,
            57500,
            60000,
            62500,
            65000,
            67500,
            70000
          ]),

      ShopUppgrade(
          Colors.brown.shade900,
          "Dividendes",
          "Gagne 1*niveau bloon a chaque génération de bloon",
          joueur.getLeNiveauDeUneUppgrade("Dividendes"),
          5,
          [150, 175, 200, 225, 250]),

      ShopUppgrade(
          Colors.cyan.shade900,
          "Investissement",
          "Augmente les gains d'un clic de 1",
          joueur.getLeNiveauDeUneUppgrade("Investissement"),
          1,
          [500]),

      ShopUppgrade(
          Colors.pink.shade900,
          "Argent de poche",
          "Gagne 10*niveau bloon a la fin de chaque partie.",
          joueur.getLeNiveauDeUneUppgrade("Argent de poche"),
          5,
          [20, 40, 80, 100, 120]),

      ShopUppgrade(
          Colors.indigo.shade900,
          "Destockage",
          "Récupère de nouvelles améliorations pour le shop chez un antiquaire",
          joueur.getLeNiveauDeUneUppgrade("Destockage"),
          1,
          [1000]),
    ];

    if (joueur.getLeNiveauDeUneUppgrade("Destockage") > 0) {
      this.uppgrades.addAll([
        ShopUppgrade(
            Colors.cyan.shade900,
            "Penny",
            "Un doublon Rouge qui arrete la génération de bloon, les rend increvable, et double les gains. Cooldown : 50 - 2*niveau secondes.",
            joueur.getLeNiveauDeUneUppgrade("Penny"),
            10,
            [
              500,
              1000,
              5000,
              10000,
              50000,
              100000,
              200000,
              300000,
              500000,
              1000000
            ]),
        ShopUppgrade(
            Colors.lightGreen.shade900,
            "Dernier profit",
            "Un portefeuille qui débloque le combot. A la fin d'une partie, gagne comboMax*niveau bloon.",
            joueur.getLeNiveauDeUneUppgrade("Dernier profit"),
            3,
            [1000, 2500, 5000]),
        ShopUppgrade(
            Colors.deepOrange.shade900,
            "Soleil",
            "Un joli collier brisé. Quand vie>90%, les gains de clic sont augmentés de 1*niveau",
            joueur.getLeNiveauDeUneUppgrade("Soleil"),
            5,
            [300, 900, 1200, 1500, 2000]),
        ShopUppgrade(
            Colors.indigoAccent.shade700,
            "Lune",
            "Un magnifique bracelet manquant son joyau. Quand vie<10%, les gains de clic sont augmentés de 3*niveau",
            joueur.getLeNiveauDeUneUppgrade("Lune"),
            5,
            [300, 900, 1200, 1500, 2000]),
        ShopUppgrade(
            Colors.redAccent.shade700,
            "Faucheuse",
            "Une faucille qui augmente de 2%/niveau les chances de soigner 1 point de vie en éclatant un ballon rouge",
            joueur.getLeNiveauDeUneUppgrade("Faucheuse"),
            5,
            [500, 1000, 1500, 2000, 2500]),
        ShopUppgrade(
            const Color.fromARGB(255, 225, 169, 0),
            "Ankh",
            "Un artefact précieux. Quand la vie arrive a zéro, une seule fois, regagne des pv égaux au comboMax",
            joueur.getLeNiveauDeUneUppgrade("Ankh"),
            1,
            [5000]),
        ShopUppgrade(
            Colors.pink.shade900,
            "Vide Grenier",
            "Gagne 100*niveau bloon a la fin de chaque partie.",
            joueur.getLeNiveauDeUneUppgrade("Vide Grenier"),
            5,
            [200, 400, 600, 800, 1000]),
        ShopUppgrade(
            Colors.indigo.shade900,
            "Tombée de Camion",
            "\"\"Récupère\"\" de nouvelles améliorations pour le shop dans le camion de déménagement d'Indiana Jones.",
            joueur.getLeNiveauDeUneUppgrade("Tombée de Camion"),
            1,
            [20000]),
      ]);
    }

    if (joueur.getLeNiveauDeUneUppgrade("Tombée de Camion") > 0) {
      this.uppgrades.addAll([
        ShopUppgrade(
            Colors.cyan.shade900,
            "Carter",
            "Une pièce de 25cts qui donne 25*niveau % de chance de doubler encore les gains de Penny.",
            joueur.getLeNiveauDeUneUppgrade("Carter"),
            10,
            [25000, 50000, 75000, 100000]),
        ShopUppgrade(
            Colors.deepOrange.shade900,
            "Couronne",
            "La partie manquante de Soleil, multipliant ses gains par 1*niveau.",
            joueur.getLeNiveauDeUneUppgrade("Couronne"),
            10,
            [
              15000,
              17000,
              19000,
              20000,
              22000,
              24000,
              25000,
              150000,
              170000,
              190000,
              200000,
              220000,
              240000,
              250000
            ]),
        ShopUppgrade(
            Colors.lightBlue.shade900,
            "Supernova",
            "Une gemme instable. Quand la vie arrive a zéro, élimine tout les bloons sur le terrain et donne 3 fois leur valeur basique",
            joueur.getLeNiveauDeUneUppgrade("Supernova"),
            1,
            [15000]),
        ShopUppgrade(
            Colors.lime.shade900,
            "Sablier Fantome",
            "Quand on clique sur l'icone, le temps arrête pendant 3 secondes. Utilisable 1*niveau par partie.",
            joueur.getLeNiveauDeUneUppgrade("Sablier Fantome"),
            7,
            [13000, 15000, 17000, 19000, 21000, 23000, 25000]),
        ShopUppgrade(
            Colors.yellow.shade900,
            "Bétile de Delphes",
            "Augmente de 1*niveau% les chances de quintupler les gains finaux d'un clic",
            joueur.getLeNiveauDeUneUppgrade("Bétile de Delphes"),
            10,
            [
              10000,
              20000,
              30000,
              40000,
              50000,
              60000,
              70000,
              80000,
              90000,
              100000
            ]),
        ShopUppgrade(
            Colors.pink.shade900,
            "Pension de Retraite",
            "\"\"Gagne\"\" 250*niveau bloon a la fin de chaque partie.",
            joueur.getLeNiveauDeUneUppgrade("Pension de Retraite"),
            5,
            [500, 1000, 1500, 2000, 2500]),
        ShopUppgrade(
            Colors.redAccent.shade700,
            "Anneau d'Osiris",
            "Un anneau qui donne 5*niveau% de chance de diminuer de 1 seconde le cooldown de Penny en éclatant un ballon bleu",
            joueur.getLeNiveauDeUneUppgrade("Anneau d'Osiris"),
            5,
            [3000, 6000, 9000, 12000, 15000]),
        ShopUppgrade(
            Colors.indigo.shade900,
            "Entente Illicite",
            "Monopolise le cyber-marché avec un concurrent pour récupérer de nouvelles cyber-améliorations",
            joueur.getLeNiveauDeUneUppgrade("Entente Illicite"),
            1,
            [75000]),
      ]);
    }

    if (joueur.getLeNiveauDeUneUppgrade("Entente Illicite") > 0) {
      this.uppgrades.addAll([
        ShopUppgrade(
            Colors.red,
            "Cyber-Vie",
            "Gagne 20 points de vie par niveau",
            joueur.getLeNiveauDeUneUppgrade("Cyber-Vie"),
            5,
            [10000, 20000, 30000, 40000, 50000]),
        ShopUppgrade(
            Colors.pink,
            "Cyber-Regénération",
            "Regenere 0.5 points de vie/seconde supplémentaire par niveau",
            joueur.getLeNiveauDeUneUppgrade("Cyber-Regénération"),
            10,
            [
              30000,
              35000,
              40000,
              45000,
              50000,
              55000,
              60000,
              65000,
              70000,
              75000
            ]),
        ShopUppgrade(
            Colors.blueGrey,
            "Cyber-Armure",
            "Réduit les dégats reçus de 1% supplémentaire par niveau",
            joueur.getLeNiveauDeUneUppgrade("Cyber-Armure"),
            10,
            [
              40000,
              42000,
              44000,
              46000,
              48000,
              50000,
              52000,
              54000,
              56000,
              58000
            ]),
        ShopUppgrade(
            Colors.yellow.shade900,
            "Cyber-Patte de Lapin",
            "Si le gain de clic n'est pas doublé, réessaye de le doubler.",
            joueur.getLeNiveauDeUneUppgrade("Cyber-Patte de Lapin"),
            1,
            [150000]),
        ShopUppgrade(
            Colors.brown.shade900,
            "Cyber-Dividendes",
            "Gagne 10*niveau bloon a chaque génération de bloon",
            joueur.getLeNiveauDeUneUppgrade("Cyber-Dividendes"),
            5,
            [60000, 70000, 80000, 90000, 100000]),
        ShopUppgrade(
            Colors.cyan.shade900,
            "Cyber-Investissement",
            "Augmente les gains d'un clic de 10",
            joueur.getLeNiveauDeUneUppgrade("Cyber-Investissement"),
            1,
            [100000]),
        ShopUppgrade(
            Colors.indigoAccent.shade700,
            "Cyber-Espace",
            "L'ultime Cyber. Quand 40%<vie<60%, les gains de clic sont augmentés de 2/niveau",
            joueur.getLeNiveauDeUneUppgrade("Cyber-Espace"),
            5,
            [100000, 125000, 150000, 175000, 200000]),
        ShopUppgrade(
            Colors.pink.shade900,
            "Cyber-Bitcoin",
            "Gagne (entre 500 et 1500) * niveau bloon a la fin de chaque partie.",
            joueur.getLeNiveauDeUneUppgrade("Cyber-Bitcoin"),
            5,
            [3000, 6000, 9000, 12000, 15000]),
        ShopUppgrade(
            Colors.indigo.shade900,
            "Cyber-Braquage",
            "Mettez vos cyber-compétences a profit de la meilleure cause (la votre) en braquant une brasserie.",
            joueur.getLeNiveauDeUneUppgrade("Cyber-Braquage"),
            1,
            [250000]),
      ]);
    }

    if (joueur.getLeNiveauDeUneUppgrade("Cyber-Braquage") > 0) {
      this.uppgrades.addAll([
        ShopUppgrade(
            const Color.fromARGB(255, 225, 169, 0),
            "Chance Liquide",
            "Bière Trappiste. 10*niveau% de chance de ne pas reset le comboMax en touchant un carré vide.",
            joueur.getLeNiveauDeUneUppgrade("Chance Liquide"),
            5,
            [300000, 350000, 400000, 450000, 500000],),
        ShopUppgrade(
            Colors.indigoAccent.shade700,
            "Ongle de Saphir",
            "La capsule d'une biere ancienne. Taillée dans le joyau de Lune, elle multiplie ses gains par 1*niveau.",
            joueur.getLeNiveauDeUneUppgrade("Ongle de Saphir"),
            10,
            [
              300000,
              350000,
              400000,
              450000,
              500000,
              550000,
              600000,
              700000,
              750000,
              800000
            ]),
        ShopUppgrade(
            Colors.pink.shade900,
            "Lampe Magique",
            "Une NEIPA fruitée. Gagne WIP*niveau bloon a la fin de chaque parties.",
            joueur.getLeNiveauDeUneUppgrade("Lampe Magique"),
            5,
            [3000, 6000, 9000, 12000, 15000]
          ),
      ]);
    }
  }

  Future<void> creeNiveauUppgradeSiExistePas() async {
    // si l'uppgrade en question n'existe pas dans le joueur , on la cree et on la sauvegarde
    for (String uppgrade in this.listeDeUppgrades) {
      if (!joueur.isUppgradeDansJoueur(uppgrade)) {
        joueur.setLeNiveauDeUneUppgrade(uppgrade, 0);
      }
    }

    await sauvegarde.saveData(joueur);
  }

  Future<void> acheteUppgrade(ShopUppgrade uppgradeAAcheter) async {
    if (joueur.getPoint() >= uppgradeAAcheter.prix) {
      setState(() {
        joueur.doUppgradeShop(uppgradeAAcheter.titre, uppgradeAAcheter.prix);
        recreeListeUppgrades(); // rebuild UI
      });

      await sauvegarde.saveData(joueur); // sauvegarde async
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!joueurCharge) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        actions: [
          Text(joueur.getPoint().toString()),
          const Icon(Icons.bubble_chart),
          Container(
            width: 50,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  isInCharacterMenu = !isInCharacterMenu;
                });
              },
              child: Icon(Icons.person_4)),
          Container(
            width: 50,
          ),
        ],
      ),
      body: Stack(
        children: [

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200, // largeur max d’une cellule
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  mainAxisExtent: 250),
              itemCount: uppgrades.length,
              itemBuilder: (context, index) {
                return buildRoundedBox(uppgrades[index]);
              },
            ),
          ),

          if (this.isInCharacterMenu) ...[
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: Colors.black.withOpacity(0.3), // assombrit légèrement
              ),
            ),
          ],

          AnimatedPositioned(
              right: this.isInCharacterMenu ? 0 : (MediaQuery.of(context).size.width * -0.35),
              top: 0,
              curve: Curves.easeOutCubic,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.35,
              duration: Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 143, 131, 131),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 20,
                      offset: Offset(-5, 0),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: listeStats.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          listeStats[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Jeu(gridSize: 10, cellSize: 40.0),
            ),
          );

          if (result == true) {
            Player joueurAJour = await sauvegarde.loadData();
            setState(() {
              joueur.reloadPlayer(joueurAJour);
            });
          }
        },
        tooltip: 'Jouer',
        backgroundColor: Color.fromARGB(255, 200, 200, 200),
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget buildRoundedBox(ShopUppgrade uppgrade) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: uppgrade.couleur.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              uppgrade.titre,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(height: 2),
            // scroll seulement si la description est trop longue
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                controller: _scrollController, // ← important
                child: SingleChildScrollView(
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
              ),
            ),
            Divider(
              height: 2,
            ),

            if (uppgrade.niveau < uppgrade.niveauMax)
              Text(
                "Niveau : ${uppgrade.niveau}/${uppgrade.niveauMax}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ElevatedButton(
              onPressed: (joueur.getPoint() >= uppgrade.prix &&
                      uppgrade.niveau < uppgrade.niveauMax)
                  ? () => acheteUppgrade(uppgrade)
                  : null,
              child: Text(
                uppgrade.niveau >= uppgrade.niveauMax
                    ? "MAX"
                    : (joueur.getPoint() >= uppgrade.prix ? "Acheter" : "X"),
              ),
            ),
            if (uppgrade.niveau < uppgrade.niveauMax)
              Text(
                "Prix : ${uppgrade.prix} Bloons",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

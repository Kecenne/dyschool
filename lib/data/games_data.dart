const List<Map<String, dynamic>> gamesList = [
  {
    "id": "jeu-de-memoire",
    "title": "Jeu de mémoire",
    "route": "/jeu/jeu-de-memoire",
    "description":
        "Le jeu de mémoire est un jeu de cartes où l'objectif est d'associer des paires identiques parmi des cartes retournées. Il fait appel à la mémoire visuelle et à la concentration. En retournant deux cartes à la fois, le joueur doit mémoriser leur position afin de former toutes les paires le plus rapidement possible.",
    "rules": [
      {
        "title": "Préparation",
        "content": "Disposez toutes les cartes face cachée sur la table de manière aléatoire."
      },
      {
        "title": "Tour de jeu",
        "content": "À chaque tour, un joueur retourne deux cartes. Si elles sont identiques, il les garde et rejoue. Sinon, elles sont remises face cachée et c'est au tour du joueur suivant."
      },
      {
        "title": "Fin de la partie",
        "content": "La partie se termine lorsque toutes les paires ont été retrouvées. Le joueur avec le plus de paires gagne."
      }
    ],
    "tags": ["Dyslexie", "Dyspraxie", "Dyséxécutif"],
    "types": ["Mémoire", "Réflexion"],
    "objectives": [
      {
        "title": "Mémoire visuelle",
        "content": "Permet d'améliorer la capacité à mémoriser des images et des positions."
      },
      {
        "title": "Concentration",
        "content": "Encourage l'attention soutenue et la réflexion stratégique."
      },
      {
        "title": "Compétition amicale",
        "content": "Apprend à jouer en respectant les règles et les autres joueurs."
      }
    ],
    "imagePath": "assets/images/memory/memory-banner.png",
  },
  {
    "id": "jeu-des-7-familles",
    "title": "Jeu des 7 familles",
    "route": "/jeu/jeu-des-7-familles",
    "description":
        "Le jeu des 7 familles est un jeu de cartes où les joueurs doivent rassembler des familles complètes en demandant aux autres joueurs les cartes qui leur manquent. Il développe les compétences sociales, la mémoire et la communication.",
    "rules": [
      {
        "title": "Distribution",
        "content": "Chaque joueur reçoit un certain nombre de cartes. Les cartes restantes forment une pioche."
      },
      {
        "title": "Tour de jeu",
        "content": "À son tour, un joueur demande une carte spécifique à un autre joueur. Si ce dernier l'a, il doit la donner. Sinon, le premier joueur pioche une carte."
      },
      {
        "title": "Victoire",
        "content": "La partie se termine lorsque toutes les familles sont complètes. Le joueur ayant complété le plus de familles gagne."
      }
    ],
    "tags": ["Dyslexie", "Dysorthographie", "Dysphasie"],
    "types": ["Stratégie", "Social"],
    "objectives": [
      {
        "title": "Compétences sociales",
        "content": "Favorise l'interaction et la communication entre joueurs."
      },
      {
        "title": "Mémoire et attention",
        "content": "Aide à se souvenir des cartes demandées et des familles en cours."
      },
      {
        "title": "Prise de décision",
        "content": "Encourage la réflexion stratégique pour optimiser ses demandes."
      }
    ],
    "imagePath": "assets/images/seven-family/seven-family-banner.png",
  },
  {
    "id": "puissance-4",
    "title": "Puissance 4",
    "route": "/jeu/puissance-4",
    "description":
        "Le Puissance 4 est un jeu de stratégie où deux joueurs s'affrontent en plaçant des pions dans une grille. L'objectif est d'aligner quatre pions de sa couleur en ligne, colonne ou diagonale avant l'adversaire.",
    "rules": [
      {
        "title": "Début de la partie",
        "content": "Les joueurs jouent chacun leur tour en faisant tomber un pion dans l'une des colonnes de la grille."
      },
      {
        "title": "Alignement",
        "content": "Le but est d'aligner 4 pions horizontalement, verticalement ou en diagonale."
      },
      {
        "title": "Fin de partie",
        "content": "La partie s'arrête lorsqu'un joueur a aligné 4 pions ou que la grille est pleine."
      }
    ],
    "tags": ["Dyscalculie", "Dyspraxie", "Dyséxécutif"],
    "types": ["Stratégie", "Réflexion"],
    "objectives": [
      {
        "title": "Planification stratégique",
        "content": "Permet de développer l'anticipation et la prise de décision."
      },
      {
        "title": "Observation",
        "content": "Aide à identifier les opportunités et les menaces dans la grille."
      }
    ],
    "imagePath": "assets/images/puissance/puissance-banner.png",
  },
  {
    "id": "qui-est-ce",
    "title": "Qui-est-ce ?",
    "route": "/jeu/qui-est-ce",
    "description": "Un jeu de déduction où chaque joueur doit deviner quel personnage l'autre a choisi en posant des questions éliminatoires.",
    "rules": [
      {
        "title": "Mise en place",
        "content": "Chaque joueur pioche une carte personnage que l'autre doit deviner."
      },
      {
        "title": "Déroulement",
        "content": "Les joueurs posent des questions pour exclure certains personnages et trouver le bon."
      },
      {
        "title": "Gagner",
        "content": "Le premier à identifier correctement le personnage adverse remporte la manche."
      }
    ],
    "tags": ["Dyslexie", "Dysphasie", "Dyséxécutif"],
    "types": ["Observation", "Réflexion"],
    "objectives": [
      {
        "title": "Déduction et logique",
        "content": "Développe l'analyse et la capacité à formuler des hypothèses."
      },
      {
        "title": "Expression orale",
        "content": "Encourage la formulation de questions précises et claires."
      }
    ],
    "imagePath": "assets/images/who/who-is-banner.png",
  },
  {
    "id": "jeu-du-simon",
    "title": "Jeu du Simon",
    "route": "/jeu/jeu-du-simon",
    "description":
        "Le jeu du Simon est un défi de mémoire et de concentration où les joueurs doivent répéter des séquences lumineuses de plus en plus longues. Chaque tour ajoute un nouvel élément à la séquence.",
    "rules": [
      {
        "title": "Début",
        "content": "Le Simon affiche une séquence de couleurs. Le joueur doit la mémoriser."
      },
      {
        "title": "Reproduction",
        "content": "Le joueur appuie sur les couleurs dans le bon ordre."
      },
      {
        "title": "Difficulté croissante",
        "content": "Chaque manche ajoute une nouvelle couleur à la séquence."
      }
    ],
    "tags": ["Dysphasie", "Dyspraxie", "Dyséxécutif"],
    "types": ["Mémoire", "Rapidité"],
    "objectives": [
      {
        "title": "Mémoire auditive et visuelle",
        "content": "Entraîne la mémoire à court terme."
      },
      {
        "title": "Réactivité",
        "content": "Améliore la rapidité de réaction face aux stimuli."
      },
      {
        "title": "Concentration",
        "content": "Exige une attention soutenue pour éviter les erreurs."
      }
    ],
    "imagePath": "assets/images/simon/simon-banner.png",
  }
];
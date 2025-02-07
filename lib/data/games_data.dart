const List<Map<String, dynamic>> gamesList = [
  {
    "id": "jeu-de-memoire",
    "title": "Jeu de mémoire",
    "route": "/jeu/jeu-de-memoire",
    "description":
        "C'est un jeu qui permet de travailler la mémoire. Tout est dans le nom enfaite. Il suffit simplement de lire.",
    "rules": [
      {
        "title": "Introduction",
        "content": "Ce jeu consiste à associer des cartes identiques parmi des cartes retournées.",
      },
      {
        "title": "Objectif",
        "content": "L'objectif est de retrouver toutes les paires de cartes avant l'adversaire.",
      },
    ],
    "tags": ["Dyslexie", "Dyspraxie"],
    "objectives": "Travailler la mémoire visuelle et la concentration.",
    "imagePath": "assets/images/memory/memory-banner.png",
  },
  {
    "id": "jeu-des-7-familles",
    "title": "Jeu des 7 familles",
    "route": "/jeu/jeu-des-7-familles",
    "description":
        "C’est un jeu de cartes où le but est de collecter des ensembles de cartes représentant différentes familles.",
    "rules": [
      {
        "title": "Introduction",
        "content":
            "Le joueur demande à un autre joueur une carte d’une famille qu’il souhaite compléter.",
      },
      {
        "title": "Objectif",
        "content":
            "Former des familles complètes en demandant les bonnes cartes aux adversaires.",
      },
    ],
    "tags": ["Dyslexie", "Dyspraxie"],
    "objectives": "Développer les compétences sociales et la planification stratégique.",
    "imagePath": "assets/images/seven-family/seven-family-banner.png",
  },
  {
  "id": "puissance-4",
  "title": "Puissance 4",
  "route": "/jeu/puissance-4",
  "description":
      "Un jeu classique où le but est d'aligner 4 pions de sa couleur horizontalement, verticalement ou en diagonale.",
  "rules": [
    {
      "title": "Introduction",
      "content": "Les joueurs déposent tour à tour un pion dans une colonne de la grille.",
    },
    {
      "title": "Objectif",
      "content": "Être le premier à aligner 4 pions de sa couleur.",
    },
  ],
  "tags": ["Dyslexie", "Dyspraxie"],
  "objectives": "Développer la logique et la réflexion stratégique.",
  "imagePath": "assets/images/puissance/puissance-banner.png",
  },
  {
  "id": "qui-est-ce",
  "title": "Qui-est-ce ?",
  "route": "/jeu/qui-est-ce",
  "description": "Devinez qui est décrit en choisissant parmi les cartes proposées. C'est assez facile puisque c'est toujours pareil.",
  "rules": [
    {
      "title": "Introduction",
      "content": "Une phrase décrit un personnage, sélectionnez la bonne carte.",
    },
    {
      "title": "Objectif",
      "content": "Répondre correctement aux 10 questions pour obtenir un score parfait.",
    },
  ],
  "tags": ["Dyslexie", "Dysphasie"],
  "objectives": "Améliorer les capacités d'inférence et de compréhension.",
  "imagePath": "assets/images/who/who-is-banner.png",
  },
  {
  "id": "jeu-du-simon",
  "title": "Jeu du Simon",
  "route": "/jeu/jeu-du-simon",
  "description":
      "Un jeu de mémoire et de concentration où il faut reproduire des séquences lumineuses de plus en plus longues.",
  "rules": [
    {
      "title": "Introduction",
      "content":
          "Le Simon affiche une séquence de couleurs que vous devez mémoriser et reproduire dans le même ordre.",
    },
    {
      "title": "Objectif",
      "content":
          "Répétez correctement les séquences pendant 20 manches pour gagner.",
    },
    {
      "title": "Attention",
      "content":
          "Chaque manche ajoute une couleur à la séquence, et la vitesse augmente à certains paliers.",
    }
  ],
  "tags": ["Dyslexie", "Dyspraxie", "Dysphasie"],
  "objectives":
      "Renforcer la mémoire auditive et visuelle, ainsi que la concentration et la rapidité de réaction.",
  "imagePath": "assets/images/simon/simon-banner.png",
}
];  
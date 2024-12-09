const List<Map<String, dynamic>> gamesList = [
  {
    "id": "jeu-de-memoire",
    "title": "Jeu de mémoire",
    "route": "/jeu/jeu-de-memoire",
    "description":
        "C'est un jeu qui permet de travailler la mémoire. Tout est dans le nom enfaite.",
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
    "imagePath": "assets/images/memory-3.jpeg",
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
    "imagePath": "assets/images/placeholder.png",
  },
];
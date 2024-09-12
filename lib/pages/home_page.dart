import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Prénom et bouton d'accessibilité
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Prénom & Nom',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: const [
                      IconButton(
                        onPressed: null,
                        icon: Icon(Icons.circle, size: 16),
                      ),
                      IconButton(
                        onPressed: null,
                        icon: Icon(Icons.circle, size: 16),
                      ),
                      IconButton(
                        onPressed: null,
                        icon: Icon(Icons.circle, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Récompenses quotidiennes
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.grey[300],
              child: Container(
                height: 400,
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: const Center(
                  child: Text(
                    'Récompenses quotidiennes',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Jeu récent
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.grey[300],
              child: Container(
                height: 150,
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: const Center(
                  child: Text(
                    'Jeu récent',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Jeux récents 2
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.grey[300],
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(16.0),
                      child: const Center(
                        child: Text(
                          'Jeux récents 2',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Recommendations
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.grey[300],
                    child: Container(
                      width: 500,
                      padding: const EdgeInsets.all(16.0),
                      child: const Center(
                        child: Text(
                          'Recommendations',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Graphique
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.grey[300],
              child: Container(
                height: 150,
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: const Center(
                  child: Text(
                    'Graphique',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Herisson
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.grey[300],
                    child: Container(
                      height: 100,
                      child: const Center(child: Text('Herisson or')),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.grey[300],
                    child: Container(
                      height: 100,
                      child: const Center(child: Text('Herisson argent')),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.grey[300],
                    child: Container(
                      height: 100,
                      child: const Center(child: Text('Herisson bronze')),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/playtime_manager.dart';
import '../data/games_data.dart';

class MonthPlaytime extends StatefulWidget {
  const MonthPlaytime({Key? key}) : super(key: key);

  @override
  State<MonthPlaytime> createState() => _MonthPlaytimeState();
}

class _MonthPlaytimeState extends State<MonthPlaytime> {
  String? selectedMonth;
  List<String> availableMonths = [];
  Map<String, Duration> typePlaytimes = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    
    try {
      final playtimeManager = Provider.of<PlaytimeManager>(context, listen: false);
      final months = await playtimeManager.getAvailableMonths();
      
      if (mounted) {
        setState(() {
          availableMonths = months;
        });
        
        // Charger les temps de jeu après avoir récupéré les mois
        await _loadPlaytimes();
      }
    } catch (e) {
      debugPrint('Error loading months: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadPlaytimes() async {
    setState(() => isLoading = true);
    
    try {
      final playtimeManager = Provider.of<PlaytimeManager>(context, listen: false);
      Map<String, Duration> newTypePlaytimes = {};
      Map<String, Set<String>> typeToGames = {};
      
      // 1. Construire un index des types vers les jeux
      for (var game in gamesList) {
        String gameId = game['id'];
        List<String> types = List<String>.from(game['types']);
        
        for (String type in types) {
          if (!typeToGames.containsKey(type)) {
            typeToGames[type] = {};
          }
          typeToGames[type]!.add(gameId);
        }
      }
      
      // 2. Pour chaque type, récupérer le temps de jeu pour chaque jeu associé
      for (String type in typeToGames.keys) {
        Duration totalForType = Duration.zero;
        
        for (String gameId in typeToGames[type]!) {
          // Récupérer le temps de jeu pour ce jeu
          Duration gameTime = selectedMonth != null 
              ? await playtimeManager.getMonthlyPlaytime(gameId, selectedMonth!)
              : await playtimeManager.getTotalPlaytime(gameId);
              
          if (gameTime > Duration.zero) {
            // Obtenir le nombre de types pour ce jeu
            int typeCount = 0;
            for (var game in gamesList) {
              if (game['id'] == gameId) {
                typeCount = List<String>.from(game['types']).length;
                break;
              }
            }
            
            // Diviser le temps de jeu par le nombre de types
            if (typeCount > 0) {
              totalForType += Duration(seconds: gameTime.inSeconds ~/ typeCount);
            }
          }
        }
        
        if (totalForType > Duration.zero) {
          newTypePlaytimes[type] = totalForType;
        }
      }
      
      if (mounted) {
        setState(() {
          typePlaytimes = newTypePlaytimes;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading playtimes: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Extraire tous les types de jeux uniques
  Set<String> getAllGameTypes() {
    Set<String> types = {};
    for (var game in gamesList) {
      List<String> gameTypes = List<String>.from(game['types']);
      types.addAll(gameTypes);
    }
    return types;
  }

  // Formater le temps en heures, minutes et secondes
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    
    if (duration.inHours > 0) {
      return '${duration.inHours} HEURE${duration.inHours > 1 ? 'S' : ''} ${twoDigits(duration.inMinutes.remainder(60))} MIN ET ${twoDigits(duration.inSeconds.remainder(60))} SECONDES';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} MIN ET ${twoDigits(duration.inSeconds.remainder(60))} SECONDES';
    } else {
      return '${duration.inSeconds} SECONDES';
    }
  }

  @override
  Widget build(BuildContext context) {
    var sortedTypes = typePlaytimes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "STATISTIQUES",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PopupMenuButton<String?>(
                onSelected: (String? newValue) {
                  if (newValue == null) {
                    // Réinitialiser complètement comme à l'initialisation
                    setState(() {
                      selectedMonth = null;
                      typePlaytimes = {};
                    });
                    _loadData();
                  } else {
                    setState(() {
                      selectedMonth = newValue;
                    });
                    _loadPlaytimes();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String?>(
                    value: null,
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          if (selectedMonth == null)
                            const Icon(Icons.check, color: Color(0xFF6B9DA4)),
                        ],
                      ),
                    ),
                  ),
                  ...availableMonths.map((String month) {
                    return PopupMenuItem<String?>(
                      value: month,
                      child: Container(
                        width: 200,
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: availableMonths.indexOf(month).isEven ? Colors.grey.shade200 : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              month,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            if (selectedMonth == month)
                              const Icon(Icons.check, color: Color(0xFF6B9DA4)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
                offset: const Offset(0, 60),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B9DA4),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedMonth ?? "Total",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (sortedTypes.isEmpty)
            const Center(
              child: Text(
                "Aucune donnée disponible pour cette période",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...sortedTypes.map((entry) => _buildStatItem(entry.key, formatDuration(entry.value))),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sports_esports, color: Color(0xFF6B9DA4)),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              time,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
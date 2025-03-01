import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/playtime_manager.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyPlaytimeGraph extends StatelessWidget {
  const WeeklyPlaytimeGraph({Key? key}) : super(key: key);

  static const int maxPlaytime = 30;

  @override
  Widget build(BuildContext context) {
    final playtimeManager = Provider.of<PlaytimeManager>(context);
    final weeklyData = playtimeManager.getWeeklyPlaytime();

    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "TEMPS DE JEU",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const SizedBox(height: 32),
              AspectRatio(
                aspectRatio: 2.5,
                child: BarChart(
                  BarChartData(
                    maxY: maxPlaytime.toDouble(),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border.symmetric(
                        horizontal: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        if (value % 10 == 0 || value == maxPlaytime) {
                          return FlLine(
                            color: Color(0xFFE0E0E0),
                            strokeWidth: 1,
                          );
                        }
                        return FlLine(color: Colors.transparent);
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            if (value == 0 || value == 10 || value == 20 || value == 30) {
                              return Text(
                                value == 30 ? "30+ min" : "${value.toInt()} min",
                                style: const TextStyle(fontSize: 12),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                _getDayLabel(value.toInt()),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                    ),
                    barGroups: _buildBarGroups(weeklyData),
                  ),
                ),
              ),

              const SizedBox(height: 24), 

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "AUJOURD'HUI",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${playtimeManager.getTodayPlaytime()} min",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              
              const SizedBox(height: 16), 
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "7 DERNIERS JOURS",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${playtimeManager.getTotalWeeklyPlaytime()} min",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Génère les barres du graphe
List<BarChartGroupData> _buildBarGroups(Map<String, int> weeklyData) {
  List<String> days = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];
  return List.generate(days.length, (index) {
    int playtime = weeklyData[days[index]] ?? 0;

    // Alterne les couleurs : une sur deux
    Color barColor = index.isEven ? const Color(0xFF3A7D85) : const Color(0xFFEF8149);

    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: playtime > maxPlaytime ? maxPlaytime.toDouble() : playtime.toDouble(),
          color: barColor,
          width: 50,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(100),
            topRight: Radius.circular(100),
          ),
        ),
      ],
    );
  });
}

  /// Récupère le label du jour en fonction de l’index
  String _getDayLabel(int index) {
    List<String> days = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];
    return days[index % days.length];
  }
}

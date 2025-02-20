import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../services/medal_manager.dart';

class RewardGraph extends StatefulWidget {
  const RewardGraph({Key? key}) : super(key: key);

  @override
  _RewardGraphState createState() => _RewardGraphState();
}

class _RewardGraphState extends State<RewardGraph> {
  DateTime? firstMedalDate;
  DateTime selectedMonth = DateTime.now();
  bool showAll = false;
  int touchedGroupIndex = -1;
  int rotationTurns = 1;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null);
    _loadFirstMedalDate();
  }

  Future<void> _loadFirstMedalDate() async {
    String? userId = Provider.of<MedalManager>(context, listen: false).currentUserId;
    if (userId == null) return;

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('medals')
        .doc('history')
        .collection('entries')
        .orderBy('timestamp', descending: false)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      Timestamp timestamp = snapshot.docs.first['timestamp'];
      setState(() {
        firstMedalDate = timestamp.toDate();
      });
    }
  }

  void _changeMonth(int offset) {
    setState(() {
      if (showAll) {
        if (offset == -1) {
          showAll = false;
          selectedMonth = DateTime.now();
        }
      } else {
        DateTime newMonth = DateTime(selectedMonth.year, selectedMonth.month + offset);

        if (firstMedalDate != null && newMonth.isBefore(firstMedalDate!)) {
          return;
        }

        if (offset == 1 && selectedMonth.year == DateTime.now().year && selectedMonth.month == DateTime.now().month) {
          showAll = true;
        } else {
          selectedMonth = newMonth;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final medalManager = Provider.of<MedalManager>(context);

    return FutureBuilder<Map<String, int>>(
      future: showAll ? medalManager.getTotalMedals() : medalManager.getMedalsByMonth(selectedMonth),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final medals = snapshot.data!;
        int maxMedals = 90;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Récompenses",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Sélecteur de mois / Tous
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF6B9DA4),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left, size: 28, color: Colors.white),
                    onPressed: (showAll || firstMedalDate == null || selectedMonth.isAfter(firstMedalDate!))
                        ? () => _changeMonth(-1)
                        : null,
                  ),
                  Column(
                    children: [
                      Text(
                        showAll
                            ? "Tous"
                            : toBeginningOfSentenceCase(DateFormat.yMMMM('fr_FR').format(selectedMonth)) ?? '',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        "${medals['gold']! + medals['silver']! + medals['bronze']!} hérissons",
                        style: const TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right, size: 28, color: Colors.white),
                    onPressed: showAll ? null : () => _changeMonth(1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AspectRatio(
              aspectRatio: 2.5,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  maxY: 90,
                  borderData: FlBorderData(
                    show: true,
                    border: const Border.symmetric(
                      horizontal: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (value % 30 == 0) {
                            return Text(value.toInt().toString(), style: const TextStyle(fontSize: 12));
                          }
                          return Container();
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return Image.asset(
                            _getMedalImage(value.toInt()),
                            width: 50,
                            height: 50,
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                  ),
                  barGroups: _buildBarGroups(medals, maxMedals),
                  barTouchData: BarTouchData(
                    enabled: true,
                    handleBuiltInTouches: false,
                    touchCallback: (event, response) {
                      if (event.isInterestedForInteractions &&
                          response != null &&
                          response.spot != null) {
                        setState(() {
                          touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                        });
                      } else {
                        setState(() {
                          touchedGroupIndex = -1;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<BarChartGroupData> _buildBarGroups(Map<String, int> medals, int maxMedals) {
    return [
      _buildBarGroup(0, medals['bronze']!, Colors.brown, maxMedals),
      _buildBarGroup(1, medals['silver']!, Colors.grey, maxMedals),
      _buildBarGroup(2, medals['gold']!, Colors.amber, maxMedals),
    ];
  }

  BarChartGroupData _buildBarGroup(int x, int value, Color color, int maxMedals) {
    double barHeight = (value / maxMedals) * maxMedals.toDouble();
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: barHeight,
          color: color,
          width: 30,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }

  String _getMedalImage(int index) {
    switch (index) {
      case 0:
        return 'assets/images/rewards/Bronze.png';
      case 1:
        return 'assets/images/rewards/Silver.png';
      case 2:
        return 'assets/images/rewards/Gold.png';
      default:
        return 'assets/images/rewards/Bronze.png';
    }
  }
}

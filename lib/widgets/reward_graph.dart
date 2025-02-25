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
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF6B9DA4),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavigationButton(Icons.arrow_back, () => _changeMonth(-1)),
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
                  _buildNavigationButton(Icons.arrow_forward, showAll ? null : () => _changeMonth(1)),
                ],
              ),
            ),
            const SizedBox(height: 24),

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
                        alignment: BarChartAlignment.spaceEvenly,
                        maxY: 90,
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
                            if (value % 30 == 0) {
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
                              reservedSize: 120,
                              getTitlesWidget: (value, meta) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 12),
                                    Image.asset(
                                      _getMedalImage(value.toInt()),
                                      width: 60,
                                      height: 60,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _getMedalCount(value.toInt(), medals),
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(),
                          topTitles: const AxisTitles(),
                        ),
                        barGroups: _buildBarGroups(medals, maxMedals),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNavigationButton(IconData icon, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Color(0xFF6B9DA4), size: 24),
      ),
    );
  }

  String _getMedalCount(int index, Map<String, int> medals) {
    return [medals['bronze']!, medals['silver']!, medals['gold']!][index].toString();
  }

  List<BarChartGroupData> _buildBarGroups(Map<String, int> medals, int maxMedals) {
    return [
      _buildBarGroup(0, medals['bronze']!, maxMedals),
      _buildBarGroup(1, medals['silver']!, maxMedals),
      _buildBarGroup(2, medals['gold']!, maxMedals),
    ];
  }

  BarChartGroupData _buildBarGroup(int x, int value, int maxMedals) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value.toDouble(),
          color: const Color(0xFF3A7D85),
          width: 50,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
        ),
      ],
    );
  }

  String _getMedalImage(int index) {
    return ['assets/images/rewards/Bronze.png', 'assets/images/rewards/Silver.png', 'assets/images/rewards/Gold.png'][index];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/medal_manager.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class RewardGraph extends StatefulWidget {
  const RewardGraph({Key? key}) : super(key: key);

  @override
  _RewardGraphState createState() => _RewardGraphState();
}

class _RewardGraphState extends State<RewardGraph> {
  DateTime? firstMedalDate;
  DateTime selectedMonth = DateTime.now();
  bool showAll = false; 

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
        int totalMedals = medals['gold']! + medals['silver']! + medals['bronze']!;
        double graphHeight = 250;

        double goldHeight = (medals['gold']! / 90) * graphHeight;
        double silverHeight = (medals['silver']! / 90) * graphHeight;
        double bronzeHeight = (medals['bronze']! / 90) * graphHeight;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Récompenses",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

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
                        "$totalMedals hérissons",
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

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: 300,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildGraphLine("90"),
                        _buildGraphLine("60"),
                        _buildGraphLine("30"),
                        _buildGraphLine("0"),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMedalColumn("assets/images/rewards/Bronze.png", bronzeHeight, medals['bronze']!),
                        _buildMedalColumn("assets/images/rewards/Silver.png", silverHeight, medals['silver']!),
                        _buildMedalColumn("assets/images/rewards/Gold.png", goldHeight, medals['gold']!),
                      ],
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

  Widget _buildGraphLine(String label) {
    return Expanded(
      child: Row(
        children: [
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Color(0xFF666666), fontSize: 12)),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
        ],
      ),
    );
  }

  Widget _buildMedalColumn(String imagePath, double barHeight, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 50,
          height: barHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF6B9DA4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Image.asset(imagePath, width: 55, height: 55),
        const SizedBox(height: 4),
        Text(
          "$count",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

}

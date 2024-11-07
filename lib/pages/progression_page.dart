import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

class ProgressionPage extends StatelessWidget {
  const ProgressionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PageHeader(title: "Progression"),
            SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(
                  "Votre progression",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
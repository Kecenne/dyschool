import 'package:flutter/material.dart';

class TagList extends StatelessWidget {
  final List<String> tags;

  const TagList({
    Key? key,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: tags
          .map(
            (tag) => Chip(
              label: Text(tag),
              backgroundColor: Colors.cyan.shade50,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.cyan.shade50,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          )
          .toList(),
    );
  }
}

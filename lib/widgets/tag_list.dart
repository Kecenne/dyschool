import 'package:flutter/material.dart';
import '../theme/app_color.dart';

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
              label: Text(
                tag,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              backgroundColor: AppColors.orangeClairColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: AppColors.orangeClairColor,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          )
          .toList(),
    );
  }
}

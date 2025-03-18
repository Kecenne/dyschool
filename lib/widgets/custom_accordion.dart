import 'package:flutter/material.dart';

class CustomAccordion extends StatefulWidget {
  final String title;
  final Widget? content;
  final bool isToggle;
  final bool value;
  final Function(bool)? onChanged;

  const CustomAccordion({
    Key? key,
    required this.title,
    this.content,
    this.isToggle = false,
    this.value = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomAccordion> createState() => _CustomAccordionState();
}

class _CustomAccordionState extends State<CustomAccordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isToggle) {
      return Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          trailing: Switch(
            value: widget.value,
            onChanged: widget.onChanged,
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          children: [
            if (widget.content != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: widget.content!,
              ),
          ],
        ),
      ),
    );
  }
} 
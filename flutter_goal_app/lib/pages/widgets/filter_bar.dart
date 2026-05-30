import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final List<String> items;
  final String? selected;
  final ValueChanged<String?> onSelect;

  const FilterBar({super.key, required this.items, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      color: Colors.black12,
      child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.all(8), children: [
        buildItem('All', selected == null, () => onSelect(null)),
        const SizedBox(width: 8),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: buildItem(item, selected == item, () => onSelect(selected == item ? null : item)),
          ),
      ]),
    );
  }

  Widget buildItem(String text, bool isSelected, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1877F2) : const Color(0xFF3A3B3C),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(text, style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ),
      );
}

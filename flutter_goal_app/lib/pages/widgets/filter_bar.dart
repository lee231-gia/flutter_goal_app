import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final String label;

  final List<String>? items;

  final String? selected;

  final ValueChanged<String?> onSelect;

  const FilterBar(
      {super.key,
      required this.label,
      required this.items,
      required this.selected,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final options = items ?? const <String>[];

    final currentValue = options.contains(selected) ? selected : null;

    return SizedBox(
      width: 148,
      child: DropdownButtonFormField<String?>(
        initialValue: currentValue,
        isExpanded: true,
        dropdownColor: const Color(0xFF242526),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFB0B3B8), fontSize: 12),
          filled: true,
          fillColor: const Color(0xFF18191A),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3A3B3C)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1877F2), width: 1.4),
          ),
        ),
        items: [
          const DropdownMenuItem<String?>(
            value: null,
            child: Text('All', overflow: TextOverflow.ellipsis),
          ),
          for (final item in options)
            DropdownMenuItem<String?>(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: onSelect,
      ),
    );
  }
}

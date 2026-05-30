import 'package:flutter/material.dart';

class GoalForm extends StatelessWidget {
  final TextEditingController title, notes;
  final String category, term, status;
  final bool isEditing;
  final VoidCallback onSave, onCancel;
  final ValueChanged<String> onCategoryChanged, onTermChanged, onStatusChanged;

  const GoalForm({
    super.key,
    required this.title,
    required this.notes,
    required this.category,
    required this.term,
    required this.status,
    required this.isEditing,
    required this.onSave,
    required this.onCancel,
    required this.onCategoryChanged,
    required this.onTermChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF242526),
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        TextField(controller: title, decoration: input('Goal title')),
        TextField(controller: notes, decoration: input('Notes')),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: menu(category, ['Personal', 'School', 'Home', 'Health', 'Work'], onCategoryChanged)),
          const SizedBox(width: 8),
          Expanded(child: menu(term, ['Short Term', 'Medium Term', 'Long Term'], onTermChanged)),
        ]),
        const SizedBox(height: 8),
        menu(status, ['Not Started', 'In Progress', 'Done'], onStatusChanged),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: FilledButton(onPressed: onSave, child: Text(isEditing ? 'Update Goal' : 'Add Goal'))),
          if (isEditing) TextButton(onPressed: onCancel, child: const Text('Cancel')),
        ]),
      ]),
    );
  }

  InputDecoration input(String label) => InputDecoration(labelText: label, labelStyle: const TextStyle(color: Color(0xFFB0B3B8)));

  Widget menu(String value, List<String> items, ValueChanged<String> onChanged) => DropdownButtonFormField<String>(
        initialValue: value,
        dropdownColor: const Color(0xFF242526),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: (value) => onChanged(value!),
      );
}

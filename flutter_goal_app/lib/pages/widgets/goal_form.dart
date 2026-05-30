import 'package:flutter/material.dart';

class GoalForm extends StatelessWidget {
  final TextEditingController title, notes;

  final List<String> categories;
  final String category, term, status;

  final bool isEditing, isSaving, showCancel;

  final Future<void> Function() onSave;
  final VoidCallback onCancel;
  final ValueChanged<String> onCategoryChanged, onTermChanged, onStatusChanged;

  const GoalForm({
    super.key,
    required this.title,
    required this.notes,
    required this.categories,
    required this.category,
    required this.term,
    required this.status,
    required this.isEditing,
    required this.isSaving,
    this.showCancel = false,
    required this.onSave,
    required this.onCancel,
    required this.onCategoryChanged,
    required this.onTermChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF242526),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextField(
                controller: title,
                textInputAction: TextInputAction.next,
                decoration: input('Goal title')),
            const SizedBox(height: 12),
            TextField(
                controller: notes,
                minLines: 1,
                maxLines: 2,
                decoration: input('Notes')),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: menu(category, categories, onCategoryChanged)),
              const SizedBox(width: 12),
              Expanded(
                  child: menu(term, ['Short Term', 'Medium Term', 'Long Term'],
                      onTermChanged)),
            ]),
            const SizedBox(height: 12),
            menu(status, ['Not Started', 'In Progress', 'Done'],
                onStatusChanged),
            const SizedBox(height: 14),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                SizedBox(
                  width: 170,
                  child: FilledButton.icon(
                    onPressed: isSaving ? null : () => onSave(),
                    icon: Icon(isEditing ? Icons.save : Icons.add),
                    label: Text(isEditing ? 'Update Goal' : 'Add Goal'),
                  ),
                ),
                if (showCancel || isEditing)
                  TextButton.icon(
                    onPressed: isSaving ? null : onCancel,
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel'),
                  ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  InputDecoration input(String label) => _decoration(label: label);

  InputDecoration _decoration({String? label}) => InputDecoration(
        labelText: label,
        labelStyle:
            label == null ? null : const TextStyle(color: Color(0xFFB0B3B8)),
        filled: true,
        fillColor: const Color(0xFF18191A),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3A3B3C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1877F2), width: 1.4),
        ),
      );

  Widget menu(
      String value, List<String> items, ValueChanged<String> onChanged) {
    final currentValue = items.contains(value) ? value : items.first;

    return DropdownButtonFormField<String>(
        initialValue: currentValue,
        isExpanded: true,
        dropdownColor: const Color(0xFF242526),
        decoration: _decoration(),
        borderRadius: BorderRadius.circular(8),
        items: items
            .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis)))
            .toList(),
        onChanged: (value) => onChanged(value!));
  }
}

import 'package:flutter/material.dart';
import '../../models/goal.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GoalCard({super.key, required this.goal, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: const Color(0xFF242526),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(goal.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
              IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, color: Color(0xFFFF6B6B))),
            ]),
            if (goal.notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(goal.notes, style: const TextStyle(color: Color(0xFFB0B3B8))),
              ),
            Wrap(spacing: 6, runSpacing: 6, children: [tag(goal.category), tag(goal.term), tag(goal.status)]),
          ]),
        ),
      ),
    );
  }

  Widget tag(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFF3A3B3C), borderRadius: BorderRadius.circular(20)),
        child: Text(text, style: const TextStyle(fontSize: 11, color: Color(0xFFB0B3B8))),
      );
}

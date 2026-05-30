import 'package:flutter/material.dart';
import '../../models/goal.dart';
import 'goal_card.dart';

class GoalList extends StatelessWidget {
  final List<Goal> goals;

  final ValueChanged<Goal> onView, onEdit, onDelete;

  const GoalList(
      {super.key,
      required this.goals,
      required this.onView,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return const Center(
          child: Text('No goals found.',
              style: TextStyle(color: Color(0xFFB0B3B8))));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
      itemCount: goals.length,
      itemBuilder: (context, index) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GoalCard(
                goal: goals[index],
                onView: () => onView(goals[index]),
                onEdit: () => onEdit(goals[index]),
                onDelete: () => onDelete(goals[index])),
          ),
        ),
      ),
    );
  }
}

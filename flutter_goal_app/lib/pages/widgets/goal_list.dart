import 'package:flutter/material.dart';
import '../../models/goal.dart';
import 'goal_card.dart';

class GoalList extends StatelessWidget {
  final List<Goal> goals;
  final ValueChanged<Goal> onEdit, onDelete;

  const GoalList({super.key, required this.goals, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return const Center(child: Text('No goals found.', style: TextStyle(color: Color(0xFFB0B3B8))));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: goals.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GoalCard(goal: goals[index], onEdit: () => onEdit(goals[index]), onDelete: () => onDelete(goals[index])),
      ),
    );
  }
}

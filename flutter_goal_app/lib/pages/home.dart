import 'package:flutter/material.dart';
import '../api_services/api_services.dart';
import '../models/goal.dart';
import 'widgets/filter_bar.dart';
import 'widgets/goal_form.dart';
import 'widgets/goal_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final api = ApiService();
  final title = TextEditingController();
  final notes = TextEditingController();
  final categories = ['Personal', 'School', 'Home', 'Health', 'Work'];
  List<Goal> goals = [];
  String category = 'Personal', term = 'Short Term', status = 'Not Started';
  String? selectedCategory;
  Goal? editing;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getGoals();
  }

  Future<void> getGoals() async {
    setState(() => isLoaded = false);
    goals = await api.getGoals(category: selectedCategory);
    setState(() => isLoaded = true);
  }

  Future<void> saveGoal() async {
    if (title.text.trim().isEmpty) return;
    await api.saveGoal(Goal(id: editing?.id, title: title.text.trim(), category: category, term: term, status: status, notes: notes.text.trim()));
    clearForm();
    await getGoals();
  }

  Future<void> deleteGoal(Goal goal) async {
    await api.deleteGoal(goal.id!);
    await getGoals();
  }

  void editGoal(Goal goal) => setState(() {
        editing = goal;
        title.text = goal.title;
        notes.text = goal.notes;
        category = goal.category;
        term = goal.term;
        status = goal.status;
      });

  void clearForm() => setState(() {
        editing = null;
        title.clear();
        notes.clear();
        category = 'Personal';
        term = 'Short Term';
        status = 'Not Started';
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18191A),
      appBar: AppBar(backgroundColor: const Color(0xFF1877F2), title: const Text('Goal Tracker', style: TextStyle(color: Colors.white))),
      body: Column(children: [
        GoalForm(
          title: title,
          notes: notes,
          category: category,
          term: term,
          status: status,
          isEditing: editing != null,
          onSave: saveGoal,
          onCancel: clearForm,
          onCategoryChanged: (value) => setState(() => category = value),
          onTermChanged: (value) => setState(() => term = value),
          onStatusChanged: (value) => setState(() => status = value),
        ),
        FilterBar(
          items: categories,
          selected: selectedCategory,
          onSelect: (value) {
            setState(() => selectedCategory = value);
            getGoals();
          },
        ),
        const Divider(height: 1, color: Color(0xFF3A3B3C)),
        Expanded(
          child: Visibility(
            visible: isLoaded,
            replacement: const Center(child: CircularProgressIndicator(color: Color(0xFF1877F2))),
            child: GoalList(goals: goals, onEdit: editGoal, onDelete: deleteGoal),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(backgroundColor: const Color(0xFF1877F2), onPressed: getGoals, child: const Icon(Icons.refresh, color: Colors.white)),
    );
  }
}

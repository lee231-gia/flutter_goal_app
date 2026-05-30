import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(const GoalApp());

class Goal {
  Goal({
    this.id,
    required this.title,
    required this.category,
    required this.term,
    required this.status,
    required this.notes,
  });

  int? id;
  String title;
  String category;
  String term;
  String status;
  String notes;

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
        id: int.parse(json['id'].toString()),
        title: json['title'] ?? '',
        category: json['category'] ?? 'Personal',
        term: json['term'] ?? 'Short Term',
        status: json['status'] ?? 'Not Started',
        notes: json['notes'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title,
        'category': category,
        'term': term,
        'status': status,
        'notes': notes,
      };
}

class LocalGoalDb {
  static Database? _db;

  Future<Database> get database async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), 'goals.db'),
      version: 1,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE goals(id INTEGER PRIMARY KEY, title TEXT, category TEXT, term TEXT, status TEXT, notes TEXT)',
      ),
    );
    return _db!;
  }

  Future<void> saveAll(List<Goal> goals) async {
    final db = await database;
    await db.delete('goals');
    for (final goal in goals) {
      await db.insert('goals', goal.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}

class ApiService {
  // Android emulator uses 10.0.2.2 for the computer's localhost.
  final String baseUrl = 'http://10.0.2.2:8000/goals.php';
  final LocalGoalDb cache = LocalGoalDb();

  Future<List<Goal>> getGoals() async {
    final response = await http.get(Uri.parse(baseUrl));
    final body = jsonDecode(response.body);
    final goals = (body['data'] as List).map((item) => Goal.fromJson(item)).toList();
    await cache.saveAll(goals);
    return goals;
  }

  Future<void> saveGoal(Goal goal) async {
    final uri = Uri.parse(baseUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(goal.toJson());
    if (goal.id == null) {
      await http.post(uri, headers: headers, body: body);
    } else {
      await http.put(uri, headers: headers, body: body);
    }
  }

  Future<void> deleteGoal(int id) async {
    await http.delete(Uri.parse('$baseUrl?id=$id'));
  }
}

class GoalApp extends StatelessWidget {
  const GoalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goal Tracker',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const GoalPage(),
    );
  }
}

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  final api = ApiService();
  final title = TextEditingController();
  final notes = TextEditingController();
  String category = 'Personal';
  String term = 'Short Term';
  String status = 'Not Started';
  Goal? editing;
  List<Goal> goals = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    goals = await api.getGoals();
    setState(() => loading = false);
  }

  Future<void> saveGoal() async {
    if (title.text.trim().isEmpty) return;
    await api.saveGoal(Goal(
      id: editing?.id,
      title: title.text.trim(),
      category: category,
      term: term,
      status: status,
      notes: notes.text.trim(),
    ));
    clearForm();
    await load();
  }

  void editGoal(Goal goal) {
    setState(() {
      editing = goal;
      title.text = goal.title;
      category = goal.category;
      term = goal.term;
      status = goal.status;
      notes.text = goal.notes;
    });
  }

  void clearForm() {
    setState(() {
      editing = null;
      title.clear();
      notes.clear();
      category = 'Personal';
      term = 'Short Term';
      status = 'Not Started';
    });
  }

  Future<void> removeGoal(int id) async {
    await api.deleteGoal(id);
    await load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Goal Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: title, decoration: const InputDecoration(labelText: 'Goal title')),
            TextField(controller: notes, decoration: const InputDecoration(labelText: 'Notes')),
            Row(children: [
              Expanded(
                child: dropdown(category, ['Personal', 'School', 'Home', 'Health', 'Work'], (v) => category = v),
              ),
              const SizedBox(width: 8),
              Expanded(child: dropdown(term, ['Short Term', 'Medium Term', 'Long Term'], (v) => term = v)),
            ]),
            dropdown(status, ['Not Started', 'In Progress', 'Done'], (v) => status = v),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: FilledButton(
                  onPressed: saveGoal,
                  child: Text(editing == null ? 'Add Goal' : 'Update Goal'),
                ),
              ),
              if (editing != null)
                TextButton(onPressed: clearForm, child: const Text('Cancel')),
            ]),
            const Divider(),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: goals.length,
                      itemBuilder: (context, index) {
                        final goal = goals[index];
                        return ListTile(
                          onTap: () => editGoal(goal),
                          title: Text(goal.title),
                          subtitle: Text('${goal.category} | ${goal.term} | ${goal.status}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => removeGoal(goal.id!),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropdown(String value, List<String> items, ValueChanged<String> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: (value) => setState(() => onChanged(value!)),
    );
  }
}

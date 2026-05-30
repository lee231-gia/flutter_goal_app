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

  final categories = [
    'Personal',
    'School',
    'Home',
    'Health',
    'Work',
    'Fitness',
    'Finance',
    'Family',
    'Travel',
    'Hobbies',
    'Spiritual',
    'Other',
  ];
  final terms = ['Short Term', 'Medium Term', 'Long Term'];
  final statuses = ['Not Started', 'In Progress', 'Done'];

  List<Goal> goals = [];

  String category = 'Personal', term = 'Short Term', status = 'Not Started';

  String? selectedCategory, selectedTerm, selectedStatus;

  String? errorMessage;

  Goal? editing;

  bool isLoading = true, isSaving = false;

  @override
  void initState() {
    super.initState();
    getGoals();
  }

  @override
  void dispose() {
    title.dispose();
    notes.dispose();
    super.dispose();
  }

  Future<void> getGoals() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedGoals = await api.getGoals(
        category: selectedCategory,
        term: selectedTerm,
        status: selectedStatus,
      );
      if (!mounted) return;
      setState(() => goals = _sortGoals(loadedGoals));
    } catch (error) {
      if (!mounted) return;
      setState(() => errorMessage = _messageFor(error));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<bool> saveGoal({
    String? categoryValue,
    String? termValue,
    String? statusValue,
  }) async {
    if (title.text.trim().isEmpty) {
      setState(() => errorMessage = 'Type a goal title before adding it.');
      return false;
    }
    if (editing != null && editing!.id == null) {
      setState(() =>
          errorMessage = 'Could not update this goal because it has no id.');
      return false;
    }
    if (isSaving) return false;

    setState(() {
      isSaving = true;
      errorMessage = null;
    });

    try {
      await api.saveGoal(Goal(
          id: editing?.id,
          title: title.text.trim(),
          category: categoryValue ?? category,
          term: termValue ?? term,
          status: statusValue ?? status,
          notes: notes.text.trim()));
      if (!mounted) return false;
      clearForm();
      await getGoals();
      return true;
    } catch (error) {
      if (!mounted) return false;
      setState(() => errorMessage = _messageFor(error));
      return false;
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  Future<void> deleteGoal(Goal goal) async {
    try {
      await api.deleteGoal(goal.id!);
      await getGoals();
    } catch (error) {
      if (!mounted) return;
      setState(() => errorMessage = _messageFor(error));
    }
  }

  void editGoal(Goal goal) => openGoalForm(goal);

  Future<void> openGoalForm([Goal? goal]) async {
    setState(() {
      editing = goal;
      title.text = goal?.title ?? '';
      notes.text = goal?.notes ?? '';
      category = goal?.category ?? 'Personal';
      term = goal?.term ?? 'Short Term';
      status = goal?.status ?? 'Not Started';
      errorMessage = null;
    });

    var formCategory = category;
    var formTerm = term;
    var formStatus = status;
    var dialogSaving = false;
    String? dialogError;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF242526),
          surfaceTintColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (dialogError != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Text(dialogError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFFFFC857))),
                    ),
                  GoalForm(
                    title: title,
                    notes: notes,
                    categories: categories,
                    category: formCategory,
                    term: formTerm,
                    status: formStatus,
                    isEditing: editing != null,
                    isSaving: dialogSaving,
                    showCancel: true,
                    onSave: () async {
                      if (title.text.trim().isEmpty) {
                        setDialogState(() {
                          dialogError = 'Type a goal title before adding it.';
                        });
                        return;
                      }

                      setDialogState(() {
                        dialogSaving = true;
                        dialogError = null;
                      });
                      final saved = await saveGoal(
                        categoryValue: formCategory,
                        termValue: formTerm,
                        statusValue: formStatus,
                      );
                      if (!dialogContext.mounted) return;
                      setDialogState(() {
                        dialogSaving = false;
                        dialogError = saved ? null : errorMessage;
                      });
                      if (saved) Navigator.of(dialogContext).pop();
                    },
                    onCancel: () => Navigator.of(dialogContext).pop(),
                    onCategoryChanged: (value) =>
                        setDialogState(() => formCategory = value),
                    onTermChanged: (value) =>
                        setDialogState(() => formTerm = value),
                    onStatusChanged: (value) =>
                        setDialogState(() => formStatus = value),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (mounted) clearForm();
  }

  void viewGoal(Goal goal) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242526),
        surfaceTintColor: Colors.transparent,
        title: Text(goal.title, style: const TextStyle(color: Colors.white)),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (goal.notes.isNotEmpty) ...[
                  Text(goal.notes,
                      style: const TextStyle(
                          color: Color(0xFFE4E6EB), height: 1.35)),
                  const SizedBox(height: 16),
                ],
                Wrap(spacing: 8, runSpacing: 8, children: [
                  _detailTag(Icons.category, goal.category),
                  _detailTag(Icons.flag, goal.term),
                  _detailTag(Icons.task_alt, goal.status),
                ]),
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            label: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              openGoalForm(goal);
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void clearForm() => setState(() {
        editing = null;
        title.clear();
        notes.clear();
        category = 'Personal';
        term = 'Short Term';
        status = 'Not Started';
      });

  String _messageFor(Object error) {
    if (error is ApiException) return error.message;
    return 'Something went wrong. Make sure the PHP API and database are running.';
  }

  List<Goal> _sortGoals(List<Goal> items) {
    final sorted = [...items];
    sorted.sort((a, b) {
      final categoryOrder = _compareByOrder(categories, a.category, b.category);
      if (categoryOrder != 0) return categoryOrder;

      final termOrder = _compareByOrder(terms, a.term, b.term);
      if (termOrder != 0) return termOrder;

      final statusOrder = _compareByOrder(statuses, a.status, b.status);
      if (statusOrder != 0) return statusOrder;

      return (b.id ?? 0).compareTo(a.id ?? 0);
    });
    return sorted;
  }

  int _compareByOrder(List<String> order, String left, String right) {
    final leftIndex = order.indexOf(left);
    final rightIndex = order.indexOf(right);
    final normalizedLeft = leftIndex == -1 ? order.length : leftIndex;
    final normalizedRight = rightIndex == -1 ? order.length : rightIndex;
    return normalizedLeft.compareTo(normalizedRight);
  }

  Widget _buildGoalContent() {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF1877F2)));
    }

    if (errorMessage != null && goals.isEmpty) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.cloud_off, color: Color(0xFFFFC857), size: 34),
              const SizedBox(height: 10),
              Text(errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFE4E6EB))),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                  onPressed: getGoals,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry')),
            ]),
          ),
        ),
      );
    }

    return GoalList(
        goals: goals, onView: viewGoal, onEdit: editGoal, onDelete: deleteGoal);
  }

  Widget _detailTag(IconData icon, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF3A3B3C),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: const Color(0xFFB0B3B8)),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Color(0xFFE4E6EB))),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18191A),
      appBar: AppBar(
          backgroundColor: const Color(0xFF1877F2),
          title: const Text('Goal Tracker',
              style: TextStyle(color: Colors.white))),
      body: Column(children: [
        Container(
          color: const Color(0xFF242526),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              FilterBar(
                label: 'Category',
                items: categories,
                selected: selectedCategory,
                onSelect: (value) {
                  setState(() => selectedCategory = value);
                  getGoals();
                },
              ),
              const SizedBox(width: 10),
              FilterBar(
                label: 'Term',
                items: terms,
                selected: selectedTerm,
                onSelect: (value) {
                  setState(() => selectedTerm = value);
                  getGoals();
                },
              ),
              const SizedBox(width: 10),
              FilterBar(
                label: 'Progress',
                items: statuses,
                selected: selectedStatus,
                onSelect: (value) {
                  setState(() => selectedStatus = value);
                  getGoals();
                },
              ),
            ]),
          ),
        ),
        const Divider(height: 1, color: Color(0xFF3A3B3C)),
        if (errorMessage != null && goals.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Text(errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFFFC857))),
            ),
          ),
        Expanded(child: _buildGoalContent()),
      ]),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add Goal',
          backgroundColor: const Color(0xFF1877F2),
          onPressed: () => openGoalForm(),
          child: const Icon(Icons.add, color: Colors.white)),
    );
  }
}

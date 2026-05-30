import 'dart:convert';
import 'package:http/http.dart' as http;
import '../database/local_goal_db.dart';
import '../models/goal.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000/goals.php';
  final LocalGoalDb cache = LocalGoalDb();

  Future<List<Goal>> getGoals({String? category, String? term}) async {
    final params = <String, String>{};
    if (category != null) params['category'] = category;
    if (term != null) params['term'] = term;
    final uri = Uri.parse(baseUrl).replace(queryParameters: params.isEmpty ? null : params);
    final response = await http.get(uri);
    if (response.statusCode != 200) return [];
    final body = jsonDecode(response.body);
    final goals = (body['data'] as List).map((item) => Goal.fromJson(item)).toList();
    await cache.saveAll(goals);
    return goals;
  }

  Future<void> saveGoal(Goal goal) async {
    final uri = Uri.parse(baseUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(goal.toJson());
    goal.id == null ? await http.post(uri, headers: headers, body: body) : await http.put(uri, headers: headers, body: body);
  }

  Future<void> deleteGoal(int id) async => http.delete(Uri.parse('$baseUrl?id=$id'));
}

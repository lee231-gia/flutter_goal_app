import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../database/local_goal_db.dart';
import '../models/goal.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? _defaultBaseUrl();

  final String baseUrl;

  final LocalGoalDb cache = LocalGoalDb();

  static String _defaultBaseUrl() {
    const configured = String.fromEnvironment('API_BASE_URL');
    if (configured.isNotEmpty) return configured;

    final host =
        kIsWeb && Uri.base.host.isNotEmpty ? Uri.base.host : 'localhost';
    return 'http://$host:8000/goals.php';
  }

  Future<List<Goal>> getGoals({
    String? category,
    String? term,
    String? status,
  }) async {
    final params = <String, String>{};
    if (category != null) params['category'] = category;
    if (term != null) params['term'] = term;
    if (status != null) params['status'] = status;

    final uri = Uri.parse(baseUrl)
        .replace(queryParameters: params.isEmpty ? null : params);
    final response = await _send(() => http.get(uri));
    if (response.statusCode != 200) {
      throw ApiException(_serverMessage(response, 'Could not load goals.'));
    }

    final body = jsonDecode(response.body);
    final data = body is Map<String, dynamic> ? body['data'] : null;
    if (data is! List) {
      throw const ApiException('The API returned an unexpected response.');
    }

    final goals = data
        .map((item) => Goal.fromJson(item as Map<String, dynamic>))
        .toList();
    try {
      await cache.saveAll(goals);
    } catch (_) {
    }
    return goals;
  }

  Future<void> saveGoal(Goal goal) async {
    final uri = Uri.parse(baseUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(goal.toJson());
    final response = await _send(
      () => goal.id == null
          ? http.post(uri, headers: headers, body: body)
          : http.put(uri, headers: headers, body: body),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(_serverMessage(response, 'Could not save the goal.'));
    }
  }

  Future<void> deleteGoal(int id) async {
    final response =
        await _send(() => http.delete(Uri.parse('$baseUrl?id=$id')));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
          _serverMessage(response, 'Could not delete the goal.'));
    }
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(const Duration(seconds: 8));
    } on TimeoutException {
      throw const ApiException(
          'The API took too long to respond. Make sure the PHP server is running on port 8000.');
    } on http.ClientException {
      throw const ApiException(
          'Could not connect to the API. Make sure the PHP server is running on port 8000.');
    }
  }

  String _serverMessage(http.Response response, String fallback) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        final message = body['error'] ?? body['message'];
        if (message is String && message.trim().isNotEmpty) return message;
      }
    } catch (_) {
    }

    return '$fallback Status ${response.statusCode}.';
  }
}

import 'dart:convert';

import 'package:task_list_api/models/task.dart';
import 'package:http/http.dart' as http;

class TaskManager {
  String url = "http://10.0.2.2:8080/task";
  Future<List<Task>> getTasks() async {
    List<Task> tasks = [];

    final response = await http.get(Uri.parse(url));

    List data = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      for (var task in data) {
        tasks.add(Task.fromMap(task));
      }
    }
    return tasks;
  }

  Future saveTask(Task task) async {
    String taskJson = jsonEncode(task.toMap());

    await http.post(Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
        body: taskJson);

    return true;
  }

  Future editTask(Task task) async {
    String taskJson = jsonEncode(task.toMap());

    await http.put(Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
        body: taskJson);

    return true;
  }

  finishTask(Task task) async {
    await http.put(Uri.parse("$url/status/${task.id}"));
  }

  deleteTask(Task task) async {
    await http.delete(Uri.parse("$url/${task.id}"));
  }
}

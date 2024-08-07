import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../helpers/db_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => [..._tasks];

  Future<void> fetchAndSetTasks() async {
    _tasks = await DBHelper.fetchTasks();
    notifyListeners();
  }

  Future<void> addTask(String title, String description, DateTime dueDate) async {
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      dueDate: dueDate,
    );
    _tasks.add(newTask);
    await DBHelper.insertTask(newTask);
    notifyListeners();
  }

  Future<void> updateTask(String id, String title, String description, DateTime dueDate) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      final updatedTask = Task(
        id: id,
        title: title,
        description: description,
        dueDate: dueDate,
        isCompleted: _tasks[taskIndex].isCompleted,
      );
      _tasks[taskIndex] = updatedTask;
      await DBHelper.updateTask(updatedTask);
      notifyListeners();
    }
  }

  Future<void> toggleTaskStatus(String id) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      await DBHelper.updateTask(_tasks[taskIndex]);
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await DBHelper.deleteTask(id);
    notifyListeners();
  }
}

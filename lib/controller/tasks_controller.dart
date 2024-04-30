import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:todo_app/model/category_model.dart';
import 'package:todo_app/model/task_model.dart';

class TasksController extends ChangeNotifier {
  final List<TaskModel> _taskList;
  int _currentIndex = 0;

  TasksController({
    required List<TaskModel> taskList,
  }) : _taskList = taskList;

  //CRUD
  UnmodifiableListView get taskList => UnmodifiableListView(_taskList);

  UnmodifiableListView currentTaskList(CategoryModel category) =>
      UnmodifiableListView(
          _taskList.where((element) => element.category == category));

  void create({
    required String category,
    required String title,
    String? detail = '',
  }) {
    _taskList.add(
      TaskModel(
        category: category,
        title: title,
        detail: detail!,
      ),
    );
    notifyListeners();
  }

  void update({
    required String hash,
    String? name,
    String? title,
    String? detail,
    bool? isChecked,
  }) {
    try {
      final int index = _indexOfHash(hash);
      _taskList[index] = _taskList[index].copyWith(
        category: name,
        title: title,
        detail: detail,
        isChecked: isChecked,
      );
      notifyListeners();
    } catch (e) {
      throw 'NOT FOUND';
    }
  }

  void delete(String hash) {
    _taskList.removeWhere((element) => element.hash == hash);
    notifyListeners();
  }

  //Ex
  TaskModel get currentTask => taskList[_currentIndex];

  int get length => _taskList.length;

  void changeIndex(String hash) {
    _currentIndex = _taskList.indexWhere((element) => element.hash == hash);
  }

  void deleteSelected(CategoryModel category) {
    _taskList.removeWhere((element) => element.category == category);
    notifyListeners();
  }

  int lengthSelected(CategoryModel currentCategory) => _taskList
      .where(
        (element) => element.category == currentCategory,
      )
      .length;

  void toggle(String hash) {
    try {
      final int index = _indexOfHash(hash);
      _taskList[index] = _taskList[index].copyWith(
        isChecked: !_taskList[index].isChecked,
      );
      notifyListeners();
    } catch (e) {
      throw 'NOT FOUND';
    }
  }

  int _indexOfHash(String hash) {
    return _taskList.indexWhere(
      (element) => element.hash == hash,
    );
  }
}

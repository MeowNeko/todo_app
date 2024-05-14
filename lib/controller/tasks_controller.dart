import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/model/category_model.dart';
import 'package:todo_app/model/task_model.dart';

class TasksController extends ChangeNotifier {
  final List<TaskModel> _taskList;
  final Box<TaskModel> _box;
  int _currentIndex = 0;

  TasksController({
    required Box<TaskModel> box,
  })  : _box = box,
        _taskList = box.values.toList();

  //CRUD
  UnmodifiableListView get taskList => UnmodifiableListView(_taskList);

  UnmodifiableListView currentTaskList(CategoryModel category) =>
      UnmodifiableListView(
          _taskList.where((element) => element.category == category));

  void create({
    required CategoryModel category,
    required String title,
    String? detail = '',
  }) {
    final task = TaskModel(
      category: category,
      title: title,
      detail: detail!,
    );

    _taskList.add(task);
    _box.add(task);

    notifyListeners();
  }

  void update({
    required String hash,
    CategoryModel? category,
    String? title,
    String? detail,
    bool? isChecked,
  }) {
    try {
      final int index = _indexOfHash(hash);
      _taskList[index] = _taskList[index].copyWith(
        category: category,
        title: title,
        detail: detail,
        isChecked: isChecked,
      );
      _box.putAt(index, _taskList[index]);
      notifyListeners();
    } catch (e) {
      throw 'NOT FOUND';
    }
  }

  void delete(String hash) {
    final index = _indexOfHash(hash);
    _taskList.removeAt(index);
    _box.deleteAt(index);
    notifyListeners();
  }

  //Ex
  TaskModel get currentTask => taskList[_currentIndex];

  int get length => _taskList.length;

  void changeIndex(String hash) {
    _currentIndex = _taskList.indexWhere((element) => element.hash == hash);
  }

  void deleteSelected(CategoryModel category) {
    final List<TaskModel> targets = [];

    _taskList.where((element) {
      targets.add(element);
      return true;
    });

    _taskList.removeWhere((element) {
      if (targets.contains(element)) {
        _box.deleteAt(_taskList.indexOf(element));
        return true;
      }

      return false;
    });

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
      _box.putAt(index, _taskList[index]);
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

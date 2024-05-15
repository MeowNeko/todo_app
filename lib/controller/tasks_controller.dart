import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:todo_app/core/databases/database_helper.dart';
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
        _taskList.where((element) => element.categoryId == category.id),
      );

  Future<void> create({
    required int categoryId,
    required String title,
    String? detail = '',
  }) async {
    final TaskModel taskModel = TaskModel(
      categoryId: categoryId,
      title: title,
      detail: detail!,
    );

    final int id = await DatabaseHelper.addTask(taskModel);
    _taskList.add(taskModel.copyWith(id: id));

    notifyListeners();
  }

  Future<void> update({
    required String hash,
    required int categoryId,
    String? title,
    String? detail,
    bool? isChecked,
  }) async {
    try {
      final int index = _indexOfHash(hash);

      _taskList[index] = _taskList[index].copyWith(
        categoryId: categoryId,
        title: title,
        detail: detail,
        isChecked: isChecked,
      );
      await DatabaseHelper.updateTask(_taskList[index]);

      notifyListeners();
    } catch (e) {
      throw 'NOT FOUND';
    }
  }

  Future<void> delete({required TaskModel task}) async {
    _taskList.removeWhere((element) => element == task);
    await DatabaseHelper.deleteTask(task);
    notifyListeners();
  }

  //Ex
  TaskModel get currentTask => taskList[_currentIndex];

  int get length => _taskList.length;

  void changeIndex(String hash) {
    _currentIndex = _taskList.indexWhere((element) => element.hash == hash);
  }

  Future<void> deleteCategorySelected(CategoryModel category) async {
    await DatabaseHelper.deleteTaskWhere(category);
    _taskList.removeWhere((element) => element.categoryId == category.id);
    notifyListeners();
  }

  int lengthCategorySelected(CategoryModel currentCategory) {
    return _taskList
        .where(
          (element) => element.categoryId == currentCategory.id,
        )
        .length;
  }

  Future<void> toggle(String hash) async {
    try {
      final int index = _indexOfHash(hash);
      _taskList[index] = _taskList[index].copyWith(
        isChecked: !_taskList[index].isChecked,
      );
      await DatabaseHelper.updateTask(_taskList[index]);
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

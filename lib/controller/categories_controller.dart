import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/model/category_model.dart';

class CategoriesController extends ChangeNotifier {
  final List<CategoryModel> _categoriesList;
  final Box _box;
  int _currentIndex = 0;

  CategoriesController({
    required Box<CategoryModel> box,
  }) : _box = box, _categoriesList = box.values.toList();

  //CRUD
  UnmodifiableListView get categoriesList =>
      UnmodifiableListView(_categoriesList);

  void create({required String name}) {
    if (_categoriesList.contains(CategoryModel(name: name))) {
      throw 'Category name is used';
    } else {
      final category = CategoryModel(name: name);

      _categoriesList.add(category);
      _box.add(category);

      notifyListeners();
    }
  }

  void update({required String name, required String newName}) {
    final category = CategoryModel(name: newName);

    try {
      if (_categoriesList.contains(category)) {
        throw 'Category name is used';
      }

      final index = _indexWhere(name);

      _categoriesList[index] = category;
      _box.putAt(index, category);

      notifyListeners();
    } catch (e) {
      if (e is String) {
        rethrow;
      }
      throw 'Category not found';
    }
  }

  void delete({required String name}) {
    CategoryModel currentModel = _categoriesList.elementAt(_currentIndex);

    _categoriesList.removeWhere(
      (element) => element == CategoryModel(name: name),
    );

    _box.deleteAt(_currentIndex);

    if (_categoriesList.contains(currentModel)) {
      _currentIndex = _categoriesList.indexOf(currentModel);
    } else {
      _currentIndex = 0;
    }

    notifyListeners();
  }

  //Ex
  int get length => _categoriesList.length;

  int get currentIndex => _currentIndex;

  String get currentName => _categoriesList[_currentIndex].name;

  CategoryModel get currentCategory => _categoriesList[_currentIndex];

  bool get isEmpty => _categoriesList.isEmpty;

  void onChange(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void onChangeName(String name) {
    _currentIndex =
        _categoriesList.indexWhere((element) => element.name == name);
    notifyListeners();
  }

  int _indexWhere(String name) =>
      _categoriesList.indexWhere((element) => element.name == name);
}

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:todo_app/core/databases/database_helper.dart';
import 'package:todo_app/model/category_model.dart';

class CategoriesController extends ChangeNotifier {
  final List<CategoryModel> _categoriesList;
  int _currentIndex = 0;

  CategoriesController({
    required List<CategoryModel> categoriesList,
  }) : _categoriesList = categoriesList;

  //CRUD
  UnmodifiableListView<CategoryModel> get categoriesList =>
      UnmodifiableListView(_categoriesList);

  Future<void> create({required String name}) async {
    final categoryModel = CategoryModel(name: name);
    if (_categoriesList.contains(categoryModel)) {
      throw 'Category name is used';
    } else {
      final int id = await DatabaseHelper.addCategory(categoryModel);
      _categoriesList.add(categoryModel.copyWith(id: id));
      notifyListeners();
    }
  }

  Future<void> update({
    required CategoryModel category,
    required String newName,
  }) async {
    try {
      if (_categoriesList.contains(CategoryModel(name: newName))) {
        throw 'Category name is used';
      }

      _categoriesList[_categoriesList.indexWhere(
        (element) => element == category,
      )] = CategoryModel(
        id: category.id,
        name: newName,
      );
      await DatabaseHelper.updateCategory(category);
      notifyListeners();
    } catch (e) {
      if (e is String) {
        rethrow;
      }
      throw 'Category not found';
    }
  }

  Future<void> delete({required CategoryModel category}) async {
    CategoryModel currentModel = _categoriesList.elementAt(_currentIndex);

    _categoriesList.removeWhere(
      (element) => element == category,
    );
    await DatabaseHelper.deleteCategory(category);

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

  int get currentId => _categoriesList[_currentIndex].id!;

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
}

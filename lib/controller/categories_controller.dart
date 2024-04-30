import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:todo_app/model/category_model.dart';

class CategoriesController extends ChangeNotifier {
  final List<CategoryModel> _categoriesList;
  int _currentIndex = 0;

  CategoriesController({
    required List<CategoryModel> categoriesList,
  }) : _categoriesList = categoriesList;

  //CRUD
  UnmodifiableListView get categoriesList =>
      UnmodifiableListView(_categoriesList);

  void create({required String name}) {
    if (_categoriesList.contains(CategoryModel(name: name))) {
      throw 'Category name is used';
    } else {
      _categoriesList.add(CategoryModel(name: name));
      notifyListeners();
    }
  }

  void update({required String name, required String newName}) {
    try {
      if (_categoriesList.contains(CategoryModel(name: newName))) {
        throw 'Category name is used';
      }

      _categoriesList[_categoriesList.indexWhere(
        (element) => element.name == name,
      )] = CategoryModel(name: newName);
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
    _currentIndex = _categoriesList.indexWhere((element) => element.name == name);
    notifyListeners();
  }

}

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/category_model.dart';
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends Equatable {
  final CategoryModel _category;
  final String _title;
  final String _detail;
  final bool _isChecked;
  final DateTime _createdDateTime = DateTime.now();

  TaskModel({
    required String category,
    required String title,
    String detail = '',
    bool isChecked = false,
  })  : _category = CategoryModel(name: category),
        _title = title,
        _detail = detail,
        _isChecked = isChecked;

  String _hash() {
    var bytes =
        utf8.encode("$_category:$_title:$_detail:$isChecked:$_createdDateTime");
    return sha256.convert(bytes).toString();
  }

  String get hash => _hash();

  @HiveField(0)
  CategoryModel get category => _category;
  @HiveField(1)
  String get title => _title;
  @HiveField(2)
  String get detail => _detail;
  @HiveField(3)
  bool get isChecked => _isChecked;

  DateTime get createdDateTime => _createdDateTime;

  String get createdDateString {
    return DateFormat('dd MMMM yyyy').format(_createdDateTime);
  }

  String get createdTimeString {
    return DateFormat('h:mm a').format(_createdDateTime);
  }

  TaskModel copyWith({
    String? category,
    String? title,
    String? detail,
    bool? isChecked,
  }) {
    return TaskModel(
      category: category ?? _category.name,
      title: title ?? _title,
      detail: detail ?? _detail,
      isChecked: isChecked ?? _isChecked,
    );
  }

  @override
  List<Object?> get props => [_hash()];
}

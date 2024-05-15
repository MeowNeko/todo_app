// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/model/category_model.dart';

class TaskModel extends Equatable {
  final int? _id;
  final int? _categoryId;
  final CategoryModel _category;
  final String _title;
  final String _detail;
  final bool _isChecked;
  final DateTime _createdDateTime = DateTime.now();

  TaskModel({
    int? id,
    int? categoryId,
    required CategoryModel category,
    required String title,
    String detail = '',
    bool isChecked = false,
  })  : _id = id,
        _categoryId = categoryId,
        _category = category,
        _title = title,
        _detail = detail,
        _isChecked = isChecked;

  String _hash() {
    var bytes =
        utf8.encode("$_category:$_title:$_detail:$isChecked:$_createdDateTime");
    return sha256.convert(bytes).toString();
  }

  int? get id => _id;

  int? get categoryId => _categoryId;

  String get hash => _hash();

  CategoryModel get category => _category;

  String get title => _title;

  String get detail => _detail;

  bool get isChecked => _isChecked;

  DateTime get createdDateTime => _createdDateTime;

  String get createdDateString {
    return DateFormat('dd MMMM yyyy').format(_createdDateTime);
  }

  String get createdTimeString {
    return DateFormat('h:mm a').format(_createdDateTime);
  }

  TaskModel copyWith({
    CategoryModel? category,
    String? title,
    String? detail,
    bool? isChecked,
  }) {
    return TaskModel(
      category: category ?? _category,
      title: title ?? _title,
      detail: detail ?? _detail,
      isChecked: isChecked ?? _isChecked,
    );
  }

  @override
  List<Object?> get props => [_hash()];

  //JSON SERIALIZATION
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': _id,
      'category_id': _categoryId,
      'title': _title,
      'detail': _detail,
      'isChecked': _isChecked,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] != null ? map['id'] as int : null,
      categoryId: map['category_id'] != null ? map['category_id'] as int : null,
      category: CategoryModel.fromMap(map['category'] as Map<String, dynamic>),
      title: map['title'] as String,
      detail: map['detail'] as String,
      isChecked: map['isChecked'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

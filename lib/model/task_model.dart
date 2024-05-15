// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class TaskModel extends Equatable {
  final int? _id;
  final int _categoryId;
  final String _title;
  final String _detail;
  final bool _isChecked;
  final DateTime _createdDateTime;

  TaskModel({
    int? id,
    required int categoryId,
    required String title,
    String detail = '',
    bool isChecked = false,
    DateTime? createdDateTime,
  })  : _id = id,
        _categoryId = categoryId,
        _title = title,
        _detail = detail,
        _isChecked = isChecked,
        _createdDateTime = createdDateTime ?? DateTime.now();

  String _hash() {
    var bytes = utf8
        .encode("$_categoryId:$_title:$_detail:$isChecked:$_createdDateTime");
    return sha256.convert(bytes).toString();
  }

  int? get id => _id;

  int get categoryId => _categoryId;

  String get hash => _hash();

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
    int? id,
    int? categoryId,
    String? title,
    String? detail,
    bool? isChecked,
  }) {
    return TaskModel(
      id: id ?? _id,
      categoryId: categoryId ?? _categoryId,
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
      'detail': _detail, //Avoid error
      'is_checked': _isChecked ? 1 : 0,
      'created_datetime': _createdDateTime.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int,
      categoryId: map['category_id'] as int,
      title: map['title'] as String,
      detail: map['detail'] as String,
      isChecked: (map['is_checked'] as int).isOdd, //1 => Odd, 0 => Even
      createdDateTime: DateTime.parse(map['created_datetime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

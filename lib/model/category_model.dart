// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int? _id;
  final String _name;

  const CategoryModel({int? id, required String name})
      : _id = id,
        _name = name;

  String _hash() {
    var bytes = utf8.encode(_name);
    return sha256.convert(bytes).toString();
  }

  int? get id => _id;
  String get name => _name;

  CategoryModel copyWith({
    String? name,
  }) {
    return CategoryModel(
      name: name ?? _name,
    );
  }

  @override
  List<Object?> get props => [_hash()];

  //JSON SERIALIZATION
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

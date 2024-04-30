import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String _name;

  const CategoryModel({required String name}) : _name = name;

  String _hash() {
    var bytes = utf8.encode(_name);
    return sha256.convert(bytes).toString();
  }

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
}

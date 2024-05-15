import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/categories_controller.dart';
import 'package:todo_app/controller/tasks_controller.dart';
import 'package:todo_app/model/category_model.dart';
import 'package:todo_app/view/extensions/general_extension.dart';

class CategoryDialog {
  static String _text = '';
  static String _current = '';

  static AlertDialog add(BuildContext context) => AlertDialog(
        title: const Text('Category Folder'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'name',
            prefixIcon: Icon(Icons.category_rounded),
          ),
          autofocus: true,
          onChanged: (value) {
            _text = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _text = '';
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              if (_text.isEmpty) {
                _snackbar(context, 'Category name is required', Colors.red);
              } else {
                try {
                  await context
                      .read<CategoriesController>()
                      .create(name: _text);

                  _text = '';
                  if (context.mounted) {
                    _snackbar(context, 'New category created', Colors.green);
                  }
                } catch (e) {
                  if (context.mounted) {
                    _snackbar(context, '$e', Colors.orange);
                  }
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      );

  static AlertDialog general(
          BuildContext context, CategoryModel categoryModel) =>
      AlertDialog(
        title: Text(
          'Category: ${categoryModel.name}',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) => edit(context, categoryModel),
              ),
              child: Card(
                semanticContainer: true,
                child: Center(
                  child: const Text('Edit').space(bottom: 10),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                await context.read<TasksController>().deleteCategorySelected(
                    context.read<CategoriesController>().currentCategory);

                if (context.mounted) {
                  if (context.read<CategoriesController>().isEmpty) {
                    _snackbar(context, 'Category not found', Colors.orange);
                  }

                  await context
                      .read<CategoriesController>()
                      .delete(category: categoryModel);

                  if (context.mounted) {
                    _snackbar(
                      context,
                      'Category ${categoryModel.name} deleted',
                      Colors.blue,
                    );
                    Navigator.pop(context);
                  }
                }
              },
              child: Card(
                semanticContainer: true,
                child: Center(
                  child: const Text('Delete').space(bottom: 10),
                ),
              ),
            ),
          ],
        ),
      );

  static AlertDialog edit(BuildContext context, CategoryModel categoryModel) =>
      AlertDialog(
        title: Text('Category: ${categoryModel.name}'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'new name',
            prefixIcon: Icon(Icons.category_rounded),
          ),
          autofocus: true,
          onChanged: (value) {
            _current = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _current = '';
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              if (_current.isEmpty) {
                _snackbar(context, 'Category name is required', Colors.red);
              } else {
                try {
                  await context.read<CategoriesController>().update(
                        category: categoryModel,
                        newName: _current,
                      );
                  _text = '';
                  if (context.mounted) {
                    _snackbar(context, 'Category name updated', Colors.green);
                  }
                } catch (e) {
                  if (context.mounted) {
                    _snackbar(context, '$e', Colors.orange);
                  }
                }

                if (context.mounted) {
                  Navigator.pop(context); //Current Dialog
                  Navigator.pop(context); //Previous Dialog
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      );

  static void _snackbar(BuildContext context, String text, Color? color) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: color,
          content: Text(text),
        ),
      );
}

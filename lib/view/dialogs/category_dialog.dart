import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/categories_controller.dart';
import 'package:todo_app/controller/tasks_controller.dart';
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
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              if (_text.isEmpty) {
                _snackbar(context, 'Category name is required', Colors.red);
              } else {
                try {
                  context.read<CategoriesController>().create(name: _text);
                  _text = '';
                  _snackbar(context, 'New category created', Colors.green);
                  Navigator.pop(context);
                } catch (e) {
                  _snackbar(context, '$e', Colors.orange);
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      );

  static AlertDialog general(BuildContext context, String name) => AlertDialog(
        title: Text(
          'Category: $name',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) => edit(context, name),
              ),
              child: Card(
                semanticContainer: true,
                child: Center(
                  child: const Text('Edit').space(bottom: 10),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                context.read<TasksController>().deleteSelected(
                    context.read<CategoriesController>().currentCategory);
                    if (context.read<CategoriesController>().isEmpty) {
                      
                    }
                context.read<CategoriesController>().delete(name: name);
                Navigator.pop(context);
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

  static AlertDialog edit(BuildContext context, String name) => AlertDialog(
        title: Text('Category: $name'),
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
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              if (_current.isEmpty) {
                _snackbar(context, 'Category name is required', Colors.red);
              } else {
                try {
                  context
                      .read<CategoriesController>()
                      .update(name: name, newName: _current);
                  _text = '';
                  _snackbar(context, 'Category name updated', Colors.green);
                  Navigator.pop(context); //Current Dialog
                  Navigator.pop(context); //Previous Dialog
                } catch (e) {
                  _snackbar(context, '$e', Colors.orange);
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

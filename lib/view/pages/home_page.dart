import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/categories_controller.dart';
import 'package:todo_app/view/extensions/general_extension.dart';
import 'package:todo_app/view/widgets/categories_widget.dart';
import 'package:todo_app/view/dialogs/category_dialog.dart';
import 'package:todo_app/view/widgets/tasks_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final spacer = const SizedBox(
    height: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your To-Do',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  IconButton(
                    onPressed: () => showDialog(
                      barrierDismissible: false,
                      builder: (context) => CategoryDialog.add(context),
                      context: context,
                    ),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),

              //SLIDER
              const Text('CATEGORIES').space(),
              const CategoriesWidget(),

              //CONTENT
              const Text('ALL TASKS').space(),
              const TodoWidget(),
            ],
          ),
        ),
      ),
      floatingActionButton: context.watch<CategoriesController>().isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, 'add-task'),
              label: const Text('New Task +'),
            ),
    );
  }
}

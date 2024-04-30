import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/categories_controller.dart';
import 'package:todo_app/controller/tasks_controller.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/view/dialogs/task_dialog.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<TasksController>(
        builder: (_, controller, __) {
          if (controller.length <= 0 ||
              controller.lengthSelected(
                      context.read<CategoriesController>().currentCategory) <=
                  0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/happy_sun.png',
                    height: 200,
                  ),
                  const Text('No task found'),
                ],
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: controller.lengthSelected(
              context.watch<CategoriesController>().currentCategory,
            ),
            itemBuilder: (context, index) {
              final category =
                  context.read<CategoriesController>().currentCategory;
              final TaskModel currentTask =
                  controller.currentTaskList(category)[index];

              return Card(
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          context
                              .read<TasksController>()
                              .changeIndex(currentTask.hash);
                          showDialog(
                            context: context,
                            builder: (context) =>
                                TaskDialog.general(context, currentTask),
                          );
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.settings,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        onPressed: (context) {
                          controller.delete(currentTask.hash);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Del',
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(currentTask.title),
                    trailing: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        currentTask.isChecked
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_rounded,
                      ),
                      onPressed: () => controller.toggle(currentTask.hash),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

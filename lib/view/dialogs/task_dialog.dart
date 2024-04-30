import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/tasks_controller.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/view/extensions/general_extension.dart';

class TaskDialog {
  static AlertDialog general(BuildContext context, TaskModel task) =>
      AlertDialog(
        title: Text(
          'Task: ${task.title}',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Created Date:',
                  overflow: TextOverflow.clip,
                ).space(bottom: 0),
                Text(
                  task.createdDateString,
                  overflow: TextOverflow.clip,
                ).space(bottom: 0),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Created Time:',
                  overflow: TextOverflow.clip,
                ).space(top: 0, bottom: 10),
                Text(
                  task.createdTimeString,
                  overflow: TextOverflow.clip,
                ).space(top: 0, bottom: 10),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'edit-task');
              },
              child: Card(
                semanticContainer: true,
                child: Center(
                  child: const Text('Edit').space(bottom: 10),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                context.read<TasksController>().delete(task.hash);
                _snackbar(context, 'Task deleted', Colors.orange);
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

  static void _snackbar(BuildContext context, String text, Color? color) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: color,
          content: Text(text),
        ),
      );
}

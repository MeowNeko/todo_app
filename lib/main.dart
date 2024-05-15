import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/categories_controller.dart';
import 'package:todo_app/controller/tasks_controller.dart';
import 'package:todo_app/core/databases/database_helper.dart';
import 'package:todo_app/theme.dart';
import 'package:todo_app/view/pages/edit_task_page.dart';
import 'package:todo_app/view/pages/home_page.dart';
import 'package:todo_app/view/pages/add_task_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final categories = await DatabaseHelper.getCategories();
  final tasks = await DatabaseHelper.getTasks();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoriesController(categoriesList: categories),
        ),
        ChangeNotifierProvider(
          create: (_) => TasksController(taskList: tasks),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do',
      theme: MyAppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (context) => const HomePage(),
        'add-task': (context) => const AddTaskPage(),
        'edit-task': (context) => const EditTaskPage(),
      },
    );
  }
}

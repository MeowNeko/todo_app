import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/categories_controller.dart';
import 'package:todo_app/controller/tasks_controller.dart';
import 'package:todo_app/model/category_model.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/theme.dart';
import 'package:todo_app/view/pages/edit_task_page.dart';
import 'package:todo_app/view/pages/home_page.dart';
import 'package:todo_app/view/pages/add_task_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Directory directory = await getApplicationDocumentsDirectory();

  Hive
    ..init(directory.path)
    ..registerAdapter(CategoryModelAdapter())
    ..registerAdapter(TaskModelAdapter());
  final categoryBox = await Hive.openBox<CategoryModel>('category');
  final taskBox = await Hive.openBox<TaskModel>('task');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoriesController(box: categoryBox),
        ),
        ChangeNotifierProvider(
          create: (_) => TasksController(box: taskBox),
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

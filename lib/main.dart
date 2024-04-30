import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/categories_controller.dart';
import 'package:todo_app/controller/tasks_controller.dart';
import 'package:todo_app/theme.dart';
import 'package:todo_app/view/pages/edit_task_page.dart';
import 'package:todo_app/view/pages/home_page.dart';
import 'package:todo_app/view/pages/add_task_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoriesController(categoriesList: []),
        ),
        ChangeNotifierProvider(
          create: (_) => TasksController(taskList: []),
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

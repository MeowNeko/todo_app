import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/categories_controller.dart';
import 'package:todo_app/controller/tasks_controller.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/view/extensions/general_extension.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _detailController;

  final _titleValidator =
      ValidationBuilder().minLength(1).maxLength(200).build();

  late final TaskModel _task;
  String _currentCategory = '';

  @override
  void initState() {
    super.initState();
    _task = context.read<TasksController>().currentTask;
    _currentCategory = _task.category.name;
    _titleController = TextEditingController(text: _task.title);
    _detailController = TextEditingController(text: _task.detail);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Task'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Consumer<CategoriesController>(
                    builder: (_, controller, __) => DropdownButtonFormField(
                      value: _currentCategory,
                      items: List.generate(
                        controller.length,
                        (index) => DropdownMenuItem(
                          value:
                              (controller.categoriesList[index].name as String),
                          child: Text(controller.categoriesList[index].name),
                        ),
                      ),
                      onChanged: (value) {
                        _currentCategory = value ?? '';
                        controller.onChangeName(value ?? '');
                      },
                    ).space(),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration().copyWith(hintText: 'title*'),
                    controller: _titleController,
                    validator: _titleValidator,
                  ).space(),
                  TextFormField(
                    maxLength: 250,
                    maxLines: null,
                    decoration:
                        const InputDecoration().copyWith(hintText: 'detail'),
                    controller: _detailController,
                  ).space(),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TasksController>().update(
                            hash: _task.hash,
                            name: _currentCategory,
                            title: _titleController.text.trim(),
                            detail: _detailController.text.trim(),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          showCloseIcon: true,
                          backgroundColor: Colors.green,
                          content: Text('Task Edited'),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

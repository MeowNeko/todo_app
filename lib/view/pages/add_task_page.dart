import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/categories_controller.dart';
import 'package:todo_app/controller/tasks_controller.dart';
import 'package:todo_app/view/extensions/general_extension.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  final _titleValidator =
      ValidationBuilder().minLength(1).maxLength(200).build();

  bool _added = false;

  // ignore: unused_field
  String _currentCategory = ''; //Used in dropdownformfield
  late final String _previousCategory;

  @override
  void initState() {
    super.initState();
    _previousCategory =
        _currentCategory = context.read<CategoriesController>().currentName;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) {
        if (!_added) {
          context.read<CategoriesController>().onChangeName(_previousCategory);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('New Task'),
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
                        value: controller.currentName,
                        items: List.generate(
                          controller.length,
                          (index) => DropdownMenuItem(
                            value: controller.categoriesList[index].name,
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
                      onPressed: () async {
                        final category =
                            context.read<CategoriesController>().currentId;
                        await context.read<TasksController>().create(
                              categoryId: category,
                              title: _titleController.text.trim(),
                              detail: _detailController.text.trim(),
                            );

                        if (context.mounted) {
                          _added = true;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              showCloseIcon: true,
                              backgroundColor: Colors.green,
                              content: Text('New task added'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
